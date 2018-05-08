//
//  TimerTableViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 06/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

//MARK: Types

struct Timers {
    var devTime: Int
    var stopTime: Int
    var fixTime: Int
    var washTime: Int
    var dryTime: Int
}

class TimerListViewController: UIViewController {
    
    //MARK: Properties
    
    let cellIdentifier = "TimerTableViewCell"
    
    var timeProcessCounter: Time!
    var counter: Int!
    
    var developTimer: Timer!
    var isPaused = true

    
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var fixTimeLabel: UILabel!
    @IBOutlet weak var washTimeLabel: UILabel!
    @IBOutlet weak var dryTimeLabel: UILabel!
    
    @IBOutlet weak var startPauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTimers()
        updateTimersViews()
//        currentTimerCountDown()
        
        // Do any additional setup after loading the view.
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Private Methods

    private func setupTimers() {
        timeProcessCounter = Time(devTime: 10, stopTime: 10, fixTime: 10, washTime: 10, dryTime: 10)
        counter = timeProcessCounter.devTime
    }

//    private func currentTimerCountDown()
//    {
//
//    }

    @objc func updateCountDown() {
        
        
        updateTimer()
        
    }

    private func updateTimersViews() {
        bigTimeLabel.text = secondsToMinutesSeconds(time: counter)
        
        devTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        stopTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
        fixTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
        washTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
        dryTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
    }
    
    private func updateTimer() {
        if timeProcessCounter.devTime > 0 {
            timeProcessCounter.devTime -= 1
            counter = timeProcessCounter.devTime
            
        } else if timeProcessCounter.stopTime > 0 {
            timeProcessCounter.stopTime -= 1
            counter = timeProcessCounter.stopTime
            
        } else if timeProcessCounter.fixTime > 0 {
            timeProcessCounter.fixTime -= 1
            counter = timeProcessCounter.fixTime
            
        } else if timeProcessCounter.washTime > 0 {
            timeProcessCounter.washTime -= 1
            counter = timeProcessCounter.washTime
            
        } else if timeProcessCounter.dryTime > 0 {
            timeProcessCounter.dryTime -= 1
            counter = timeProcessCounter.dryTime
        }
        
        updateTimersViews()
    }
    
    func secondsToMinutesSeconds (time counter: Int) -> (String) {
        
        let minutes = counter/60
        let seconds = counter - minutes * 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    //MARK: Actions
    
    @IBAction func startPauseTimeAction(_ sender: UIButton) {
        
        if isPaused{
            developTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            isPaused = false
            startPauseButton.setTitle("Пауза", for: .normal)
        } else {
            developTimer.invalidate()
            isPaused = true
            startPauseButton.setTitle("Старт", for: .normal)
        }
    }
    
    @IBAction func resetTimeAction(_ sender: UIButton) {
        setupTimers()
        developTimer.invalidate()
        isPaused = true
        updateTimersViews()
    }
    
    
}
