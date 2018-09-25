//
//  TimerVC.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 13/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

enum TimerStages: String {
    case developing = "devTime"
    case stopping = "stopTime"
    case fixing = "fixTime"
    case washing = "washTime"
    case drying = "dryTime"
    
    var initialStage: TimerStages {
        get {
            return .developing
        }
    }
    
    var nextStage: TimerStages {
        get {
            switch self {
            case .developing:
                return .stopping
            case .stopping:
                return .fixing
            case .fixing:
                return .washing
            case .washing:
                return .drying
            default:
                return .drying
            }
        }
    }
}

class TimerVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var playButton: CircularButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var bottomProgressBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetButtonHeightConstraint: NSLayoutConstraint!
    
    var stage: TimerStages = .developing
    
    //MARK: - Properties
    var timeProcessCounter = TimerConfig()
    
    var timer: Timer?
    var counter: Int = 0
    var offsetCounter: Int = 0
    var requestDate = Date()
    
    let fontSizeSmall: CGFloat = 41
    let fontSizeBig: CGFloat = 55
    
    var currentTimerName: String?
    var nextTimerName: String?
    
    var isPaused = true
    var timerValues: [String: Int] = ["devTime": 0, "stopTime": 0, "fixTime": 0, "washTime": 0, "dryTime": 0]
    
    var kFacktor: CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }
    
    var progressView: PTProgressView?
//    var stage: SubViews = .developing

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initSubtimersValue()
        setupTimerValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subtimersView.configureLabels(with: timeProcessCounter)
        updateMainTimerLabel(forTimerValue: timeProcessCounter.devTime)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initProgressBars()
    }
    
    // MARK: - Configure UI
    func configureUI() {
        addEditButton()
        setResetButtonStyle()
        setNavigationBarStyle()
//        adoptMainTimerLableToScreenSize()
        
        initialStateUI()
    }
    
    func addEditButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editConfigButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func setResetButtonStyle() {
        resetButton.backgroundColor = .clear
        resetButton.layer.cornerRadius = 5
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.black.cgColor
        
//        resetButtonHeightConstraint.constant = 48 * kFacktor
    }
    
    func setNavigationBarStyle() {
        navigationController?.makeNavigationBarTransparent()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func adoptMainTimerLableToScreenSize() {
        totalTimeLabel.font = UIFont(name: ".SFUIText-Semibold", size: CGFloat(fontSizeSmall * kFacktor))
        bottomProgressBarConstraint.constant = 67 * kFacktor
    }
    
    // MARK: -
    func initProgressBars() {
        progressBar.maxBarValue = Float(counter)
        subtimersView.maxBarValue = Double(counter)
    }
    
    func initSubtimersValue() {
        timerValues = ["devTime": timeProcessCounter.devTime, "stopTime": timeProcessCounter.stopTime, "fixTime": timeProcessCounter.fixTime, "washTime": timeProcessCounter.washTime, "dryTime": timeProcessCounter.dryTime]
    }
    
    func setupTimerValue() {
        guard let timerValue = timerValues[stage.rawValue] else { return }
        counter = timerValue
        currentTimerName = stage.rawValue
        nextTimerName = stage.nextStage.rawValue
    }
    
    func updateMainTimerLabel(forTimerValue timerValue: Int = 0) {
        totalTimeLabel.text = timerValue.secondsToMinutesSeconds()
    }
    
    @objc func handleTimer() {
        if counter > 0 {
            counter -= 1
            
            progressBar.currentValue = Float(counter)
            subtimersView.currentBarValue = Double(counter)
            updateMainTimerLabel(forTimerValue: counter)
        } else {
            stage = stage.nextStage
            subtimersView.progressBars.removeFirst()
            
            stopTimer()
            
            setupTimerValue()
            initProgressBars()
            updateMainTimerLabel(forTimerValue: counter)
        }
    }
    
    func stopTimer() {
        
    }
    
    func disableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func enableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

// MARK: - Actions
extension TimerVC {
    @IBAction func startPause(_ sender: CircularButton) {
        
        if isPaused{
            subtimersView.isFlipped = isPaused
            isPaused = false
            playButton.isPlayButton = false
            
            disableBacklightTimer()
            startStateUI()
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        } else {
            subtimersView.isFlipped = isPaused
            isPaused = true
            playButton.isPlayButton = true
            
            enableBacklightTimer()
            pauseStateUI()
            
            timer?.invalidate()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func editConfigButtonTapped() {
        
    }
}

// MARK: - Animation
extension TimerVC {
    func initialStateUI() {
        progressBar.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        playButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        resetButton.transform = CGAffineTransform(translationX: 0, y: 50).scaledBy(x: 0.5, y: 0.5)
        resetButton.alpha = 0
        
        totalTimeLabel.transform = CGAffineTransform(translationX: 0, y: 50).scaledBy(x: 0.9, y: 0.9)
    }
    
    func startStateUI() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.progressBar.transform = .identity
                        self?.playButton.transform = .identity
                        self?.resetButton.transform = .identity
                        self?.resetButton.alpha = 1
                        
                        self?.totalLabel.transform = CGAffineTransform(translationX: 0, y: -70).scaledBy(x: 0.5, y: 0.5)
                        self?.totalLabel.alpha = 0
                        
                        self?.totalTimeLabel.transform = .identity
            },
                       completion: nil)
    }
    
    func pauseStateUI() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.resetButton.transform = CGAffineTransform(translationX: 0, y: 50).scaledBy(x: 0.5, y: 0.5)
                        self?.resetButton.alpha = 0
                        
                        self?.totalLabel.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
                        self?.totalLabel.alpha = 1
                        
                        self?.totalTimeLabel.transform = CGAffineTransform(translationX: 0, y: 50).scaledBy(x: 0.9, y: 0.9)
            },
                       completion: nil)
    }
}

extension TimerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
