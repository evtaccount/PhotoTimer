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
    
    var incomingTimer: RealmDevelop?
    var timeProcessCounter: RealmDevelop
    var startTimers = RealmDevelop(schemeName: "", filmName: "", developerName: "", devTime: 0, stopTime: 0, fixTime: 0, washTime: 0, dryTime: 0, firstAgitationDuration: 0, periodAgitationDuration: 0, agitationPeriod: 0)
    
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
    
    //"Start/Pause" button
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var navigationBarTimer: UINavigationItem!
    
    
    //MARK: Initialization
    convenience init() {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        timeProcessCounter = startTimers
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        circularProgressBar.currentTimerTrackLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160))
        setupTimers()
        updateAllTimersView()
        navigationItem.title = timeProcessCounter.schemeName
        
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
    
    //MARK: Actions
    @IBAction func editButtonPressedAction(_ sender: UIBarButtonItem) {
        
        guard let configuratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "configuratorViewController") as? ConfiguratorViewController else {
            return
        }
        
        let currentTimer = timeProcessCounter
        configuratorViewController.currentConfiguration = currentTimer
        self.navigationController?.pushViewController(configuratorViewController, animated: true)
    }
    
    //MARK: Private Methods

    private func setupTimers() {
        guard let schemeName = incomingTimer?.schemeName,
            let filmName = incomingTimer?.filmName,
            let developerName = incomingTimer?.developerName,
            let devTime = incomingTimer?.devTime,
            let stopTime = incomingTimer?.stopTime,
            let fixTime = incomingTimer?.fixTime,
            let washTime = incomingTimer?.washTime,
            let dryTime = incomingTimer?.washTime,
            let firstAgitationDuration = incomingTimer?.firstAgitationDuration,
            let periodAgitationDuration = incomingTimer?.periodAgitationDuration,
            let agitationPeriod = incomingTimer?.agitationPeriod else {
                return
        }
        startTimers = RealmDevelop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        
        timeProcessCounter = RealmDevelop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        
        circularProgressBar.maxBarValue = Float(timeProcessCounter.devTime)
        circularProgressBar.maxSegmentValue = Float(timeProcessCounter.devTime)
        timerName = "devTime"
        circularProgressBar.currentSegmentIsActive = timerName!
        circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: timerName!)
        
        resetButton.isEnabled = false
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
            countTimer(currentTimer: &timeProcessCounter.devTime, nextTimer: &timeProcessCounter.stopTime, nextTimerName: "stopTime")
            
        case "stopTime":
            countTimer(currentTimer: &timeProcessCounter.stopTime, nextTimer: &timeProcessCounter.fixTime, nextTimerName: "fixTime")
            
        case "fixTime":
            countTimer(currentTimer: &timeProcessCounter.fixTime, nextTimer: &timeProcessCounter.washTime, nextTimerName: "washTime")
            
        case "washTime":
            countTimer(currentTimer: &timeProcessCounter.washTime, nextTimer: &timeProcessCounter.dryTime, nextTimerName: "dryTime")
            
        case "dryTime":
            countTimer(currentTimer: &timeProcessCounter.dryTime, nextTimer: &timeProcessCounter.devTime, nextTimerName: "devTimer")
           
        default:
            fatalError("Case вышел за пределы цикцла")
        }
        
        
    }
    
    func countTimer(currentTimer: inout Int, nextTimer: inout Int, nextTimerName: String) {
        if currentTimer > 0 {
            currentTimer -= 1
            circularProgressBar.currentValue = Float(currentTimer)
            circularProgressBar.currentSegmentValue = Float(currentTimer)
        } else {
            circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: nextTimerName)
            circularProgressBar.maxBarValue = Float(nextTimer)
            circularProgressBar.maxSegmentValue = Float(nextTimer)
            timerName = nextTimerName
            
//            circularProgressBar.currentSegmentIsActive = nextTimerName
            
            stopTimer()
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
            
        case "stopTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
            
        case "fixTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
            
        case "washTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
            
        case "dryTime":
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
            
        default:
            fatalError("Вышел за пределы цикла")
        }
    }
    
    //Обновляет UI элементы всех таймеров. Используется для инициализации
    private func updateAllTimersView() {
        
        bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        devTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        stopTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
        fixTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
        washTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
        dryTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
    }

    //Конвертация секунд а минуты и секунды в заданном формате (ММ:СС). Используется для вывода понятных пользователю данных
    private func secondsToMinutesSeconds (time counter: Int) -> (String) {
        let minutes = counter / 60
        let seconds = counter % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    //Останавливает таймер
    private func stopTimer() {
        timeCounter?.invalidate()
        isPaused = true
        startPauseButton.setTitle("Старт", for: .normal)
        resetButton.isEnabled = true
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
        
    }
    
    //MARK: Actions
    @IBAction func startPauseTimeAction(_ sender: UIButton) {
        
        if isPaused{
//            circularProgressBar.firstTimeIn = true
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            isPaused = false
            startPauseButton.setTitle("Пауза", for: .normal)
            resetButton.isEnabled = false

            navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false // Не работает
//            navigationController?.navigationBar.tintColor = UIColor.lightGray
        } else {
            stopTimer()
        }
    }
    
    @IBAction func resetTimeAction(_ sender: UIButton) {
        setupTimers()
        timeCounter?.invalidate()
        isPaused = true
        updateAllTimersView()
        circularProgressBar.currentTimerTrackLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160))
        circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: timerName!)
    }
    
    
}
