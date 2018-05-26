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
    
    //Переменная таймера
    var timeCounter: Timer?
    
    //Флаг для установки таймера на паузу
    var isPaused = true
    
    //Переменная хранит имя текущего таймера
    var currentTimerName: String?
    var nextTimerName: String?
    let timerNamesCycle = ["devTime":"stopTime", "stopTime":"fixTime", "fixTime":"washTime", "washTime":"dryTime", "dryTime":"devTime"]
    
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
        
        currentTimerName = "devTime"
        nextTimerName = timerNamesCycle[currentTimerName!]
        circularProgressBar.currentSegmentIsActive = currentTimerName!
        
        circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: currentTimerName!)
        
        resetButton.isEnabled = false
    }

    //Функция вызывается по каждому тику таймера
    @objc func updateCountDown() {
        updateTimer(for: currentTimerName)
        updateCurrentTimersView(for: currentTimerName)
    }
    
    //Фенкция выполняет декримент текущего таймера и переключает таймер на следующий когда значение текущего таймера достигает нуля
    private func updateTimer(for timer: String!) {
        
        guard let timer = timer else {
            fatalError("unknown timer's name")
        }
        
        switch timer {
        case "devTime":
            countTimer(currentTimer: &timeProcessCounter.devTime, nextTimer: &timeProcessCounter.stopTime)
            
        case "stopTime":
            countTimer(currentTimer: &timeProcessCounter.stopTime, nextTimer: &timeProcessCounter.fixTime)
            
        case "fixTime":
            countTimer(currentTimer: &timeProcessCounter.fixTime, nextTimer: &timeProcessCounter.washTime)
            
        case "washTime":
            countTimer(currentTimer: &timeProcessCounter.washTime, nextTimer: &timeProcessCounter.dryTime)
            
        case "dryTime":
            countTimer(currentTimer: &timeProcessCounter.dryTime, nextTimer: &timeProcessCounter.devTime)
           
        default:
            fatalError("Case вышел за пределы цикцла")
        }
        
        
    }
    
    func countTimer(currentTimer: inout Int, nextTimer: inout Int) {
        if currentTimer > 0 {
            currentTimer -= 1
            circularProgressBar.currentValue = Float(currentTimer)
            circularProgressBar.currentSegmentValue = Float(currentTimer)
        } else {
            circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: nextTimerName!)
            circularProgressBar.maxBarValue = Float(nextTimer)
            circularProgressBar.maxSegmentValue = Float(nextTimer)
            
            currentTimerName = nextTimerName
            nextTimerName = timerNamesCycle[currentTimerName!]
            
            stopTimer()
        }
    }
    
    func hideNavigationButtons() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    func showNavigationButtons() {
        navigationItem.setHidesBackButton(false, animated:true)
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.08, green: 0.49, blue: 0.98, alpha: 1.0)
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
    
    //Останавливает таймер, включает автоблокировку экрана
    private func stopTimer() {
        timeCounter?.invalidate()
        isPaused = true
        startPauseButton.setTitle("Старт", for: .normal)
        resetButton.isEnabled = true
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = true
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    //MARK: Actions
    @IBAction func startPauseTimeAction(_ sender: UIButton) {
        
        if isPaused{
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            isPaused = false
            startPauseButton.setTitle("Пауза", for: .normal)
            resetButton.isEnabled = false
            
            UIApplication.shared.isIdleTimerDisabled = true

            hideNavigationButtons()
        } else {
            stopTimer()
            showNavigationButtons()
        }
    }
    
    @IBAction func resetTimeAction(_ sender: UIButton) {
        setupTimers()
        timeCounter?.invalidate()
        isPaused = true
        updateAllTimersView()
        circularProgressBar.currentTimerTrackLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160))
        circularProgressBar.currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: currentTimerName!)
    }
    
    
}
