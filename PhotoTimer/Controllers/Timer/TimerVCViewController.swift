//
//  TimerVCViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 16/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class TimerVCViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var button: CircularButton!
    @IBOutlet weak var subtimersView: SubtimersView!
    @IBOutlet weak var progressBar: PTProgressBar!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: - Properties
    var isPused: Bool = true
    
    var selectedTimer: TimerConfig?
    var timeProcessCounter = TimerConfig()
    
    var timerCounter: Timer?
    
    var timerValues = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initTimer() {
        guard let id = selectedTimer?.id,
            let schemeName = selectedTimer?.schemeName,
            let filmName = selectedTimer?.filmName,
            let developerName = selectedTimer?.developerName,
            let devTime = selectedTimer?.devTime,
            let stopTime = selectedTimer?.stopTime,
            let fixTime = selectedTimer?.fixTime,
            let washTime = selectedTimer?.washTime,
            let dryTime = selectedTimer?.washTime,
            let firstAgitationDuration = selectedTimer?.firstAgitationDuration,
            let periodAgitationDuration = selectedTimer?.periodAgitationDuration,
            let agitationPeriod = selectedTimer?.agitationPeriod
            else { return }
        
        timeProcessCounter = TimerConfig(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        timeProcessCounter.id = id
        timerValues = ["devTime": timeProcessCounter.devTime, "stopTime": timeProcessCounter.stopTime, "fixTime": timeProcessCounter.fixTime, "washTime": timeProcessCounter.washTime, "dryTime": timeProcessCounter.dryTime]
    }

    func setupTimerSegmentLabels() {
        subtimersView.developLabel.text = timeProcessCounter.devTime.secondsToMinutesSeconds()
        subtimersView.stopLabel.text = timeProcessCounter.stopTime.secondsToMinutesSeconds()
        subtimersView.fixingLabel.text = timeProcessCounter.fixTime.secondsToMinutesSeconds()
        subtimersView.washingLabel.text = timeProcessCounter.washTime.secondsToMinutesSeconds()
        subtimersView.dryingLabel.text = timeProcessCounter.dryTime.secondsToMinutesSeconds()
    }
    
    @IBAction func hideMenu(_ sender: CircularButton) {
        subtimersView.hideMenu()
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
