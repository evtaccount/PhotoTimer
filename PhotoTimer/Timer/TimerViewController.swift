    //
    //  TimerTableViewController.swift
    //  PhotoTimer
    //
    //  Created by Evgeny Evtushenko on 06/05/2018.
    //  Copyright © 2018 EVT. All rights reserved.
    //
    
    import UIKit

    
    class TimerViewController: UIViewController {
        
        
        //MARK: Properties
        var incomingTimer: RealmDevelop?
        var timeProcessCounter = RealmDevelop(schemeName: "", filmName: "", developerName: "", devTime: 0, stopTime: 0, fixTime: 0, washTime: 0, dryTime: 0, firstAgitationDuration: 0, periodAgitationDuration: 0, agitationPeriod: 0)
        
        //Переменная таймера
        var timeCounter: Timer?
        
        var counter: Int = 0
        
        //Флаг для установки таймера на паузу
        var isPaused = true
        
        //Переменные хранят имя текущего и следующего таймера соответственно
        var currentTimerName: String?
        var nextTimerName: String?
        
        //Словарь используется для переключения на следующий таймер ключу эквивалентному по имени текущего
        let timerNamesCycle = ["devTime":"stopTime", "stopTime":"fixTime", "fixTime":"washTime", "washTime":"dryTime", "dryTime":"devTime"]
        var timerValues = [String: Int]()
        
        
        //MARK: Outlets
        //Круговой прогресс-бар
        @IBOutlet weak var circularProgressBar: CircularProgressBar!
        
        //Ярлыки для отображения значений таймеров
        @IBOutlet weak var bigTimeLabel: UILabel!
        @IBOutlet weak var devTimeLabel: UILabel!
        @IBOutlet weak var stopTimeLabel: UILabel!
        @IBOutlet weak var fixTimeLabel: UILabel!
        @IBOutlet weak var washTimeLabel: UILabel!
        @IBOutlet weak var dryTimeLabel: UILabel!
        
        //Кнопки "Старт/Пауза" и "Сброс"
        @IBOutlet weak var startPauseButton: UIButton!
        @IBOutlet weak var resetButton: UIButton!
        
        
        //MARK: Life cycle
        //Когда экран загрузился, инициализируем экземпляры класса в методе "setupTimersValue" и выводим заданные в выбранной конфигурации значения таймеров
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupTimersValue()
            
            devTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
            stopTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.stopTime)
            fixTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.fixTime)
            washTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.washTime)
            dryTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.dryTime)
            
            setupFirstTimerValue()
            
            navigationItem.title = timeProcessCounter.schemeName
            circularProgressBar.alpha = 0.0
            resetButton.isEnabled = false
        }
        
        //Теперь, когда загрузился интерфейс, инициируем круговой прогресс-бар
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            
            setupCircularProgressBar()
            UIView.animate(withDuration: 0.5, animations: {
                self.circularProgressBar.alpha = 1.0
            })
        }
        
        //MARK: Actions
        //Отправляем текущий таймер в конфигуратор для редактирования
        @IBAction func editButtonPressedAction(_ sender: UIBarButtonItem) {
            guard let configuratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "configuratorViewController") as? ConfiguratorViewController else {
                return
            }
            
            let currentTimer = timeProcessCounter
            configuratorViewController.currentConfiguration = currentTimer
            self.navigationController?.pushViewController(configuratorViewController, animated: true)
        }
        
        
        //MARK: Private Methods
        //Инициация конфигурации выбранного из БД таймера
        private func setupTimersValue() {
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
            
            timeProcessCounter = RealmDevelop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
            
            timerValues = ["devTime": timeProcessCounter.devTime, "stopTime": timeProcessCounter.stopTime, "fixTime": timeProcessCounter.fixTime, "washTime": timeProcessCounter.washTime, "dryTime": timeProcessCounter.dryTime]
        }
        
        //Инициация кругового прогресс-бара
        private func setupCircularProgressBar() {
            guard let timerName = currentTimerName else {
                return
            }
            circularProgressBar.initTrackLayerSegment()
            initCircularProgressBars(maxValue: timeProcessCounter.devTime, segmentName: timerName)
        }
        
        //Метод выполняет декримент текущего таймера и переключает на следующий, елси текущий таймер достиг нуля
        private func updateTimer() {
            if counter > 0 {
                counter -= 1
                updateCurrentValuesCircularProgressBar(currentValue: counter)
            } else {
                guard let timerName = nextTimerName else {
                    return
                }
                
                guard let timerValue = timerValues[timerName] else {
                    return
                }
                
                initCircularProgressBars(maxValue: timerValue, segmentName: timerName)
                
                counter = timerValue
                
                currentTimerName = timerName
                nextTimerName = timerNamesCycle[timerName]
                
                stopTimer()
            }
        }
        
        //Устанавливает текущее значение текущего таймера на круговом прогресс-баре
        private func updateCurrentValuesCircularProgressBar(currentValue: Int) {
            circularProgressBar.currentValue = Float(currentValue)
            circularProgressBar.currentSegmentValue = Float(currentValue)
        }
        
        //Инициирует сегмент на круговом прогресс-баре
        private func initCircularProgressBars(maxValue: Int, segmentName: String) {
            circularProgressBar.maxBarValue = Float(maxValue)
            circularProgressBar.maxSegmentValue = Float(maxValue)
            circularProgressBar.currentSegmentIsActive = segmentName
        }
        
        //Костыль, который скрывает кнопки на navigationItem
        private func hideNavigationButtons() {
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            
            navigationItem.setHidesBackButton(true, animated:true)
        }
        
        //Второй костыль, который делает их доступными и видимыми вновь
        private func showNavigationButtons() {
            navigationItem.setHidesBackButton(false, animated:true)
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.08, green: 0.49, blue: 0.98, alpha: 1.0)
        }
        
        //Конвертация секунд а минуты и секунды в заданном формате (ММ:СС). Используется для вывода понятных пользователю данных
        private func secondsToMinutesSeconds (time counter: Int) -> (String) {
            let minutes = counter / 60
            let seconds = counter % 60
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
        
        //Останавливает таймер, включает автоблокировку экрана
        private func stopTimer() {
            UIApplication.shared.isIdleTimerDisabled = false
            
            timeCounter?.invalidate()
            isPaused = true
            startPauseButton.setTitle("Старт", for: .normal)
            resetButton.isEnabled = true
        }
        
        //Настраивает счетчик на первый таймер. Обновляет главный таймер
        private func setupFirstTimerValue() {
            counter = timeProcessCounter.devTime
            currentTimerName = "devTime"
            nextTimerName = timerNamesCycle[currentTimerName!]
            
            bigTimeLabel.text = secondsToMinutesSeconds(time: timeProcessCounter.devTime)
        }
        
        //Функция вызывается по каждому тику таймера
        @objc func updateCountDown() {
            updateTimer()
            bigTimeLabel.text = secondsToMinutesSeconds(time: counter)
        }
        
        
        //MARK: Actions
        @IBAction func startPauseTimeAction(_ sender: UIButton) {
            if isPaused{
                timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
                
                UIApplication.shared.isIdleTimerDisabled = true
                isPaused = false
                startPauseButton.setTitle("Пауза", for: .normal)
                resetButton.isEnabled = false
                
                hideNavigationButtons()
            } else {
                stopTimer()
            }
        }
        
        @IBAction func resetTimeAction(_ sender: UIButton) {
            setupTimersValue()
            setupCircularProgressBar()
            circularProgressBar.resetCircles()
            setupFirstTimerValue()
            
            timeCounter?.invalidate()
            isPaused = true
            showNavigationButtons()

        }
    }
