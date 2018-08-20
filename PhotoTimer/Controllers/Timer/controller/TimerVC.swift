//
//  TimerVC.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 13/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var playButton: CircularButton!
    @IBOutlet weak var subtimersView: SubtimersView!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timerName: UILabel!
    
    @IBOutlet weak var bottomProgressBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetButtonHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var timeProcessCounter = TimerConfig()
    
    var timeCounter: Timer?
    var counter: Int = 0
    var offsetCounter: Int = 0
    var requestDate = Date()
    
    let fontSizeSmall: CGFloat = 45
    let fontSizeBig: CGFloat = 100
    
    var currentTimerName: String?
    var nextTimerName: String?
    
    var isPaused = true
    var timerValues = [String: Int]()
    
    var kFacktor: CGFloat {
        return UIScreen.main.bounds.width / 375.0
    }

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        initTimer()
        subtimersView.configureLabels(with: timeProcessCounter)
        
        setupFirstTimerValue()
        updateMainTimerLabel(forTimerValue: timeProcessCounter.devTime)
        
        timerName.text = currentTimerName
        
        adoptMainTimerLableToScreenSize()
        setNavigationBarStyle()
//        setNavigationBarTiltle()
//        setButtonsStyle()
//        disableResetButton()
        hideCircularProgressBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initCircularProgressBar()
        showCircularProgressBar()
    }
    
    func hideCircularProgressBar() {
        progressBar.alpha = 0.0
    }
    
    func showCircularProgressBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBar.alpha = 1.0
        })
    }
    
    func initCircularProgressBar() {
        progressBar.maxBarValue = Float(counter)
//        guard let timerName = currentTimerName else {
//            return
//        }
//        circularProgressBar.clearSegmentLayers()
//        circularProgressBar.initTrackLayerSegment()
//        initCircularProgressBars(maxValue: timeProcessCounter.devTime, segmentName: timerName)
    }
    
    func adoptMainTimerLableToScreenSize() {
        
        totalTimeLabel.font = UIFont(name: ".SFUIText-Semibold", size: CGFloat(55 * kFacktor))
        bottomProgressBarConstraint.constant = 67 * kFacktor
//        progressBar.layoutIfNeeded()
    }
    
    func configureUI() {
        self.navigationController?.makeNavigationBarTransparent()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editConfigButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        
        resetButtonHeightConstraint.constant = 30 * kFacktor
        
        resetButton.backgroundColor = .clear
        resetButton.layer.cornerRadius = 5
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func initTimer() {
        timerValues = ["devTime": timeProcessCounter.devTime, "stopTime": timeProcessCounter.stopTime, "fixTime": timeProcessCounter.fixTime, "washTime": timeProcessCounter.washTime, "dryTime": timeProcessCounter.dryTime]
    }
    
    func setupFirstTimerValue() {
        counter = timeProcessCounter.devTime
        currentTimerName = "devTime"
        nextTimerName = TimerConst.timerNamesCycle[currentTimerName!]
    }
    
    func setNavigationBarStyle() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func updateMainTimerLabel(forTimerValue timerValue: Int) {
        totalTimeLabel.text = timerValue.secondsToMinutesSeconds()
    }
    
    @objc func handleTimer() {
        let sec = Int(-self.requestDate.timeIntervalSinceNow)
        
        progressBar.currentValue = Float(counter - sec)
        totalTimeLabel.text = (counter - sec).secondsToMinutesSeconds()
        
        if counter + offsetCounter < sec {
            guard let currentName = self.nextTimerName else {
                return
            }
            
            guard let timerValue = self.timerValues[currentName] else {
                return
            }
            
            //            initCircularProgressBars(maxValue: timerValue, segmentName: timerName)
            
            self.counter = timerValue
            self.currentTimerName = currentName
            progressBar.maxBarValue = Float(timerValue)
            self.nextTimerName = TimerConst.timerNamesCycle[currentName]
            self.stopTimer()
            shrink()
            
            timerName.text = currentTimerName
            
            totalTimeLabel.text = counter.secondsToMinutesSeconds()
        }
    }
    
    func stopTimer() {
        enableBacklightTimer()
        
        timeCounter?.invalidate()
        isPaused = true
        playButton.isPlayButton = true
        resetButton.isEnabled = true
        subtimersView.isFlipped = false
    }
    
    func disableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func enableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func shrink() {
        let labelCopy = totalTimeLabel.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = totalTimeLabel.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: totalTimeLabel.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.totalTimeLabel.transform = shrinkTransform
        }, completion: { _ in
            self.totalTimeLabel.font = labelCopy.font
            self.totalTimeLabel.transform = .identity
            self.totalTimeLabel.bounds = smallerBounds
        })
    }
    
    func enlarge() {
        var biggerBounds = totalTimeLabel.bounds
        totalTimeLabel.font = totalTimeLabel.font.withSize(fontSizeBig)
        biggerBounds.size = totalTimeLabel.intrinsicContentSize
        
        totalTimeLabel.transform = scaleTransform(from: biggerBounds.size, to: totalTimeLabel.bounds.size)
        totalTimeLabel.bounds = biggerBounds
        
        UIView.animate(withDuration: 0.5) {
            self.totalTimeLabel.transform = .identity
        }
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
}

// MARK: - Actions
extension TimerVC {
    @IBAction func startPause(_ sender: CircularButton) {
        
        if isPaused{
            subtimersView.isFlipped = isPaused
//            timerName.isHidden = true
            requestDate = .init()
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            
            disableBacklightTimer()
            isPaused = false
            playButton.isPlayButton = false
            resetButton.isEnabled = false
            
            UIView.animate(withDuration: 0.5) {
                self.resetButton.alpha = 0
            }
//            hideNavigationButtons()
            
            enlarge()
        } else {
//            subtimersView.isFlipped = isPaused
            counter -= Int(-self.requestDate.timeIntervalSinceNow)
            
            UIView.animate(withDuration: 0.5) {
                self.resetButton.alpha = 1
            }
            
            stopTimer()
            
            shrink()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timerName.text = "Total time"
    }
    
    @objc func editConfigButtonTapped() {
        
    }
}

extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
    }
}
