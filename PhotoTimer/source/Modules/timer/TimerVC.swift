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
    @IBOutlet weak var subtimersView: SubtimersView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
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
    
    let fontSizeSmall: CGFloat = 45
    let fontSizeBig: CGFloat = 100
    
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
        resetButton.isHidden = true
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
        adoptMainTimerLableToScreenSize()
        
        //        totalTimeLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
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
        
        resetButtonHeightConstraint.constant = 30 * kFacktor
    }
    
    func setNavigationBarStyle() {
        navigationController?.makeNavigationBarTransparent()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func adoptMainTimerLableToScreenSize() {
        totalTimeLabel.font = UIFont(name: ".SFUIText-Semibold", size: CGFloat(55 * kFacktor))
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
        enableBacklightTimer()
        timer?.invalidate()
        isPaused = true
        playButton.isPlayButton = true
        resetButton.isEnabled = true
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
            requestDate = .init()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            
            disableBacklightTimer()
            isPaused = false
            playButton.isPlayButton = false
            resetButton.isEnabled = false
        } else {
            subtimersView.isFlipped = isPaused
            
            stopTimer()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func editConfigButtonTapped() {
        
    }
}

// MARK: - Animation
extension TimerVC {
    
    func shrink() {
        
        let labelCopy = totalTimeLabel.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = totalTimeLabel.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: totalTimeLabel.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .curveLinear], animations: {
            self.totalTimeLabel.transform = shrinkTransform
        }) { (_) in
            self.totalTimeLabel.font = labelCopy.font
            self.totalTimeLabel.transform = .identity
            self.totalTimeLabel.bounds = smallerBounds
        }
    }
    
    func enlarge() {
        var biggerBounds = totalTimeLabel.bounds
        totalTimeLabel.font = totalTimeLabel.font.withSize(fontSizeBig)
        biggerBounds.size = totalTimeLabel.intrinsicContentSize
        
        totalTimeLabel.transform = scaleTransform(from: biggerBounds.size, to: totalTimeLabel.bounds.size)
        totalTimeLabel.bounds = biggerBounds
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .curveLinear], animations: {
            self.totalTimeLabel.transform = .identity
        }, completion: nil)
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
}
