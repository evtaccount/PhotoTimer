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

class TimerViewController: UIViewController {
    
    //MARK: Properties
    
    let cellIdentifier = "TimerTableViewCell"
    
    var timeProcessCounter: Timers
    var startTimers: Timers
    
    var timeCounter: Timer?
    var isPaused = true
    
    var timerName: String?
    
    //Main circular progress-bar
    @IBOutlet weak var circularProgressBar: CircularProgressBar!
    
    //Timer labels
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var fixTimeLabel: UILabel!
    @IBOutlet weak var washTimeLabel: UILabel!
    @IBOutlet weak var dryTimeLabel: UILabel!
    
    //Linear sub-prosses's progress bars
    @IBOutlet weak var devProgressBar: UIProgressView!
    @IBOutlet weak var stopProgressBar: UIProgressView!
    @IBOutlet weak var fixProgressBar: UIProgressView!
    @IBOutlet weak var washProgressBar: UIProgressView!
    @IBOutlet weak var dryProgressBar: UIProgressView!
    
    //"Start/Pause" button
    @IBOutlet weak var startPauseButton: UIButton!
    
    
    //MARK: Initialization
    convenience init() {
        self.init()
        
        startTimers = Timers(devTime: 10, stopTime: 10, fixTime: 10, washTime: 10, dryTime: 10)
        timeProcessCounter = startTimers
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        startTimers = Timers(devTime: 10, stopTime: 10, fixTime: 10, washTime: 10, dryTime: 10)
        timeProcessCounter = startTimers

        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTimers()
        updateAllTimersView()
        
        
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
        circularProgressBar.maxBarValue = Float(timeProcessCounter.devTime)
        timerName = "devTime"
    }

    //Функция вызывается по каждому тику таймера
    @objc func updateCountDown() {
        
        updateTimer(for: timerName)
        updateCurrentTimersView(for: timerName)
    }
    
    //Фенкция выполняет декримент текущего таймера и переключает таймер на следующий когда значение текущего таймера достигает нуля
    private func updateTimer(for timer: String!) {
        
        guard let timer = timer else {
            fatalError("unknown timer's name")
        }
        
        switch timer {
        case "devTime":
            if timeProcessCounter.devTime > 0 {
                timeProcessCounter.devTime -= 1
                circularProgressBar.currentValue = Float(timeProcessCounter.devTime)
            } else {
                stopTimer()
                timerName = "stopTime"
                circularProgressBar.maxBarValue = Float(timeProcessCounter.stopTime)
            }
            
        case "stopTime":
            if timeProcessCounter.stopTime > 0 {
                timeProcessCounter.stopTime -= 1
                circularProgressBar.currentValue = Float(timeProcessCounter.stopTime)
            } else {
                stopTimer()
                timerName = "fixTime"
                circularProgressBar.maxBarValue = Float(timeProcessCounter.fixTime)
            }
            
        case "fixTime":
            if timeProcessCounter.fixTime > 0 {
                timeProcessCounter.fixTime -= 1
                circularProgressBar.currentValue = Float(timeProcessCounter.fixTime)
            } else {
                stopTimer()
                timerName = "washTime"
                circularProgressBar.maxBarValue = Float(timeProcessCounter.washTime)
            }
            
        case "washTime":
            if timeProcessCounter.washTime > 0 {
                timeProcessCounter.washTime -= 1
                circularProgressBar.currentValue = Float(timeProcessCounter.washTime)
            } else {
                stopTimer()
                timerName = "dryTime"
                circularProgressBar.maxBarValue = Float(timeProcessCounter.dryTime)
            }
            
        case "dryTime":
            if timeProcessCounter.dryTime > 0 {
                timeProcessCounter.dryTime -= 1
                circularProgressBar.currentValue = Float(timeProcessCounter.dryTime)
            } else {
                stopTimer()
                timerName = "devTimer"
                circularProgressBar.maxBarValue = Float(timeProcessCounter.devTime)
            }
        default:
            fatalError("Case вышел за пределы цикцла")
        }
        
        
    }

    //Обновляет UI элементы текущего таймера
    private func updateCurrentTimersView(for timer: String?) {
        
        guard let timer = timer else {
            fatalError("unknown timer's name")
        }
        
        switch timer {
        case "devTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
            progressBarUpdate(startValue: startTimers.devTime, currentValue: timeProcessCounter.devTime, progressBar: devProgressBar)
            
        case "stopTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
            progressBarUpdate(startValue: startTimers.stopTime, currentValue: timeProcessCounter.stopTime, progressBar: stopProgressBar)
            
        case "fixTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
            progressBarUpdate(startValue: startTimers.fixTime, currentValue: timeProcessCounter.fixTime, progressBar: fixProgressBar)
            
        case "washTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
            progressBarUpdate(startValue: startTimers.washTime, currentValue: timeProcessCounter.washTime, progressBar: washProgressBar)
            
        case "dryTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
            progressBarUpdate(startValue: startTimers.dryTime, currentValue: timeProcessCounter.dryTime, progressBar: dryProgressBar)
            
        default:
            fatalError("Вышел за пределы цикла")
        }
    }
    
    //Обновляет UI элементы всех таймеров. Используется для инициализации
    private func updateAllTimersView() {
        
        bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        
        devTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        progressBarUpdate(startValue: startTimers.devTime, currentValue: timeProcessCounter.devTime, progressBar: devProgressBar)
        
        stopTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
        progressBarUpdate(startValue: startTimers.stopTime, currentValue: timeProcessCounter.stopTime, progressBar: stopProgressBar)
        
        fixTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
        progressBarUpdate(startValue: startTimers.fixTime, currentValue: timeProcessCounter.fixTime, progressBar: fixProgressBar)
        
        washTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
        progressBarUpdate(startValue: startTimers.washTime, currentValue: timeProcessCounter.washTime, progressBar: washProgressBar)
        
        dryTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
        progressBarUpdate(startValue: startTimers.dryTime, currentValue: timeProcessCounter.dryTime, progressBar: dryProgressBar)
    }

    //Конвертация секунд а минуты и секунды в заданном формате (ММ:СС). Используется для вывода понятных пользователю данных
    private func secondsToMinutesSeconds (time counter: Int) -> (String) {
        let minutes = counter/60
        let seconds = counter - minutes * 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    //Фенкция обновляет UIProgressView который передается в функцию в качестве аргумента. Также принимается начальное значение таймера и его текущее состояние
    private func progressBarUpdate(startValue: Int, currentValue: Int, progressBar: UIProgressView) {
        let start = Float(startValue)
        let current = Float(currentValue)
        let progress = (start-current)/start
        progressBar.setProgress(progress, animated: true)
    }
    
    //Останавливает таймер
    private func stopTimer() {
        timeCounter?.invalidate()
        isPaused = true
        startPauseButton.setTitle("Старт", for: .normal)
    }
    
    //MARK: Actions
    @IBAction func startPauseTimeAction(_ sender: UIButton) {
        
        if isPaused{
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            isPaused = false
            startPauseButton.setTitle("Пауза", for: .normal)
        } else {
            stopTimer()
        }
    }
    
    @IBAction func resetTimeAction(_ sender: UIButton) {
        setupTimers()
        timeCounter?.invalidate()
        isPaused = true
        updateAllTimersView()
    }
    
    
}
