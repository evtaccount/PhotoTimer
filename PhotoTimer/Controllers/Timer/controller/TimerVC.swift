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
    
    //MARK: - Properties
    var timeProcessCounter = TimerConfig()
    
    var timeCounter: Timer?
    var counter: Int = 0
    var requestDate = Date()
    
    var currentTimerName: String?
    var nextTimerName: String?
    
    //Флаги
    var isPaused = true
    
    //Словарь используется для переключения на следующий таймер по ключу эквивалентному имени текущего
    //    let timerNamesCycle = ["devTime":"stopTime", "stopTime":"fixTime", "fixTime":"washTime", "washTime":"dryTime", "dryTime":"devTime"]
    var timerValues = [String: Int]()

    //MARK: - Life cycle
    //Когда экран загрузился, инициализируем экземпляры класса в методе "setupTimersValue" и выводим заданные в выбранной конфигурации значения таймеров
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        initTimer()
        subtimersView.configureLabels(with: timeProcessCounter)
        
        setupFirstTimerValue()
        updateMainTimerLabel(forTimerValue: timeProcessCounter.devTime)
        
//        adoptMainTimerLableToScreenSize()
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
        progressBar.initProgressBar()
        progressBar.maxBarValue = CGFloat(counter)
//        guard let timerName = currentTimerName else {
//            return
//        }
//        circularProgressBar.clearSegmentLayers()
//        circularProgressBar.initTrackLayerSegment()
//        initCircularProgressBars(maxValue: timeProcessCounter.devTime, segmentName: timerName)
    }
    
    func configureUI() {
        self.navigationController?.makeNavigationBarTransparent()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editConfigButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
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
        
        progressBar.currentValue = CGFloat(counter - sec)
        totalTimeLabel.text = (counter - sec).secondsToMinutesSeconds()
        
        if counter <= sec {
            guard let timerName = self.nextTimerName else {
                return
            }
            
            guard let timerValue = self.timerValues[timerName] else {
                return
            }
            
            //            initCircularProgressBars(maxValue: timerValue, segmentName: timerName)
            
            self.counter = timerValue
            self.currentTimerName = timerName
            self.nextTimerName = TimerConst.timerNamesCycle[timerName]
            self.stopTimer()
            totalTimeLabel.text = counter.secondsToMinutesSeconds()
        }
    }
    
    func stopTimer() {
        enableBacklightTimer()
        
        timeCounter?.invalidate()
        isPaused = true
        playButton.isPlayButton = true
        resetButton.isEnabled = true
        subtimersView.hideShowMenu()
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
        subtimersView.hideShowMenu()
        
        if isPaused{
            requestDate = Date()
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
            
            disableBacklightTimer()
            isPaused = false
            playButton.isPlayButton = false
            resetButton.isEnabled = false
            
//            hideNavigationButtons()
        } else {
            stopTimer()
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
    }
    
    @objc func editConfigButtonTapped() {
        
    }
}
