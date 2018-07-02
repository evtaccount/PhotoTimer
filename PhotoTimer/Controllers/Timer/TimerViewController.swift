//
//  TimerTableViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 06/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit


class TimerViewController: UIViewController {
    //MARK: - Outlets
    //Круговой прогресс-бар
    @IBOutlet weak var circularProgressBar: CircularProgressBar!
    
    //Ярлыки для отображения значений таймеров
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var devTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var fixTimeLabel: UILabel!
    @IBOutlet weak var washTimeLabel: UILabel!
    @IBOutlet weak var dryTimeLabel: UILabel!
    
    //Stack views
    @IBOutlet weak var devStackView: UIStackView!
    @IBOutlet weak var stopStackView: UIStackView!
    @IBOutlet weak var fixStackView: UIStackView!
    @IBOutlet weak var washStackView: UIStackView!
    @IBOutlet weak var dryStackView: UIStackView!
    
    //Кнопки "Старт/Пауза" и "Сброс"
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    //MARK: - Properties
    var incomingTimer: TimerConfig?
    var timeProcessCounter = TimerConfig(schemeName: "", filmName: "", developerName: "", devTime: 0, stopTime: 0, fixTime: 0, washTime: 0, dryTime: 0, firstAgitationDuration: 0, periodAgitationDuration: 0, agitationPeriod: 0)
    
    //Переменная таймера
    var timeCounter: Timer?
    
    var counter: Int = 0
    
    //Флаг для установки таймера на паузу
    var isPaused = true
    
    //Переменные хранят имя текущего и следующего таймера соответственно
    var currentTimerName: String?
    var nextTimerName: String?
    
    //Словарь используется для переключения на следующий таймер ключу эквивалентному по имени текущего
//    let timerNamesCycle = ["devTime":"stopTime", "stopTime":"fixTime", "fixTime":"washTime", "washTime":"dryTime", "dryTime":"devTime"]
    var timerValues = [String: Int]()
    
    
    //MARK: - Life cycle
    //Когда экран загрузился, инициализируем экземпляры класса в методе "setupTimersValue" и выводим заданные в выбранной конфигурации значения таймеров
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCurrentTimer()
        setupTimerSegmentLabels()
        
        setupFirstTimerValue()
        updateMainTimerLabel(forTimerValue: timeProcessCounter.devTime)
        
        adoptMainTimerLableToScreenSize()
        setNavigationBarStyle()
        setNavigationBarTiltle()
        setButtonsStyle()
        disableResetButton()
        hideCircularProgressBar()
    }
    
    //Теперь, когда загрузился интерфейс, инициируем круговой прогресс-бар
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initCircularProgressBar()
        showCircularProgressBar()
    }

    
    //MARK: - Methods
    //MARK: View-methods
    func setButtonsStyle() {
        startPauseButton.startStyle()
        resetButton.resetStyle()
    }
    
    func setNavigationBarStyle() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func adoptMainTimerLableToScreenSize() {
        var kFacktor: CGFloat {
            return UIScreen.main.bounds.width/375.0
        }
        
        bigTimeLabel.font = UIFont(name: ".SFUIText-Semibold", size: CGFloat(55 * kFacktor))
    }
    
    func disableResetButton() {
        resetButton.isEnabled = false

    }
    
    func hideCircularProgressBar() {
        circularProgressBar.alpha = 0.0
    }
    
    func showCircularProgressBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.circularProgressBar.alpha = 1.0
        })
    }
    
    func setNavigationBarTiltle() {
        navigationItem.title = timeProcessCounter.schemeName
    }
    
    func setupTimerSegmentLabels() {
        devTimeLabel.text = timeProcessCounter.devTime.secondsToMinutesSeconds()
        stopTimeLabel.text = timeProcessCounter.stopTime.secondsToMinutesSeconds()
        fixTimeLabel.text = timeProcessCounter.fixTime.secondsToMinutesSeconds()
        washTimeLabel.text = timeProcessCounter.washTime.secondsToMinutesSeconds()
        dryTimeLabel.text = timeProcessCounter.dryTime.secondsToMinutesSeconds()
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
    
    func updateMainTimerLabel(forTimerValue timerValue: Int) {
        bigTimeLabel.text = timerValue.secondsToMinutesSeconds()
    }
    
    //Инициация кругового прогресс-бара
    func initCircularProgressBar() {
        guard let timerName = currentTimerName else {
            return
        }
        circularProgressBar.clearSegmentLayers()
        circularProgressBar.initTrackLayerSegment()
        initCircularProgressBars(maxValue: timeProcessCounter.devTime, segmentName: timerName)
    }
    
    //Устанавливает текущее значение текущего таймера на круговом прогресс-баре (и на главном и на сегменте)
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
    
    //MARK: - Controller-methods
    //Настраивает счетчик на первый таймер. Обновляет главный таймер
    func setupFirstTimerValue() {
        counter = timeProcessCounter.devTime
        currentTimerName = "devTime"
        nextTimerName = TimerConst.timerNamesCycle[currentTimerName!]
    }
    
    //Инициация конфигурации выбранного из БД таймера
    func initCurrentTimer() {
        guard let id = incomingTimer?.id,
            let schemeName = incomingTimer?.schemeName,
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
        
        timeProcessCounter = TimerConfig(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        timeProcessCounter.id = id
        
        timerValues = ["devTime": timeProcessCounter.devTime, "stopTime": timeProcessCounter.stopTime, "fixTime": timeProcessCounter.fixTime, "washTime": timeProcessCounter.washTime, "dryTime": timeProcessCounter.dryTime]
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
            nextTimerName = TimerConst.timerNamesCycle[timerName]
            
            stopTimer()
        }
    }
    
    func rgbToCGFloat(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        let redFloat = CGFloat(Float(red)/255.0)
        let greenFloat = CGFloat(Float(green)/255.0)
        let blueFloat = CGFloat(Float(blue)/255.0)
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: CGFloat(alpha))
    }
    
    //Останавливает таймер, включает автоблокировку экрана
    func stopTimer() {
        enableBacklightTimer()
        
        timeCounter?.invalidate()
        isPaused = true
        startPauseButton.setTitle("Старт", for: .normal)
        resetButton.isEnabled = true
    }
    
    func disableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func enableBacklightTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    //Функция вызывается по каждому тику таймера
    @objc func updateCountDown() {
        updateTimer()
        updateMainTimerLabel(forTimerValue: counter)
    }
//    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
//        view.translatesAutoresizingMaskIntoConstraints = false
//        stackView.insertSubview(view, at: 0)
//        view.pin(to: stackView)
//    }
    
//    private func backgroundView(color: UIColor) -> UIView {
//        let view = UIView()
//        view.backgroundColor = color
//        view.layer.cornerRadius = 10.0
//        return view
//    }
}

//public extension UIView {
//    public func pin(to view: UIView) {
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topAnchor.constraint(equalTo: view.topAnchor),
//            bottomAnchor.constraint(equalTo: view.bottomAnchor)
//            ])
//    }
//}

//MARK: - Actions
extension TimerViewController {
    //Отправляем текущий таймер в конфигуратор для редактирования
    @IBAction func editButtonPressedAction(_ sender: UIBarButtonItem) {
        guard let configuratorViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.coonfiguratorVC) as? ConfiguratorViewController else {
            return
        }
        
        let currentTimer = timeProcessCounter
        configuratorViewController.currentConfiguration = currentTimer
        configuratorViewController.fromTimer = true
        self.navigationController?.pushViewController(configuratorViewController, animated: true)
    }
    
    @IBAction func resetTimeAction(_ sender: UIButton) {
        initCurrentTimer()
        initCircularProgressBar()
        circularProgressBar.resetCircles()
        setupFirstTimerValue()
        updateMainTimerLabel(forTimerValue: timeProcessCounter.devTime)
        
        resetButton.isEnabled = false
        
        timeCounter?.invalidate()
        isPaused = true
        showNavigationButtons()
    }
    
    @IBAction func startPauseTimeAction(_ sender: UIButton) {
        if isPaused{
            timeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
            
            disableBacklightTimer()
            isPaused = false
            startPauseButton.setTitle("Пауза", for: .normal)
            resetButton.isEnabled = false
            
            hideNavigationButtons()
        } else {
            stopTimer()
        }
    }
}
