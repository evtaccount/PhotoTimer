//
//  SetTimeViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 16/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import os.log

class SetTimeViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var setTimeTableView: UITableView!
    @IBOutlet weak var secondsCountDownPicker: UIPickerView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Properties
    let cellIdentifier = "setTimerCell"
    var selectedTimer = 0
    var cameFrom: String?
    
    let minutesAndSeconds: [Int] = [
        0,   1,  2,  3,  4,  5,  6,  7,  8,  9,
        10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
        30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
        40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
        50, 51, 52, 53, 54, 55, 56, 57, 58, 59
    ]
    
    var timers: [TimersList] = [
        TimersList(timerName: "Таймер проявки", timerValue: 0),
        TimersList(timerName: "Таймер стоп-ванны", timerValue: 0),
        TimersList(timerName: "Таймер фиксажа", timerValue: 0),
        TimersList(timerName: "Таймер промывки", timerValue: 0),
        TimersList(timerName: "Таймер сушки", timerValue: 0)
    ]
    
    var agitationScheme: [TimersList] = [
        TimersList(timerName: "Сначала", timerValue: 0),
        TimersList(timerName: "Далее", timerValue: 0),
        TimersList(timerName: "Повторять каждые", timerValue: 0)
    ]
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        let startIndexPath = IndexPath(row: 0, section: 0)
        if let startScrollPosition = UITableViewScrollPosition(rawValue: 0) {
            tableview.selectRow(at: startIndexPath, animated: true, scrollPosition: startScrollPosition)
        }
    }

    //MARK: Private methods
    private func setup() {
        let minutes = timers[0].timerValue! / 60
        let seconds = timers[0].timerValue! % 60
        
        secondsCountDownPicker.selectRow(minutes, inComponent: 0, animated: true)
        secondsCountDownPicker.selectRow(seconds, inComponent: 1, animated: true)
    }
    
    private func secondsToMinutesAndSeconds(timeInSeconds timerValue: Int) -> String {
        let minutes = timerValue / 60
        let seconds = timerValue % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    // MARK: - Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    }
}

//MARK: Table view
extension SetTimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cameFrom = cameFrom else {
            fatalError()
        }
        if cameFrom == "set timers" {
            return timers.count
        } else {
            return agitationScheme.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cameFrom = cameFrom else {
            fatalError()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SetTimeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SetTimeTableViewCell.")
        }
        
        if cameFrom == "set timers" {
            let timer = timers[indexPath.row]
            
            cell.timerNameLabel.text = timer.timerName
            cell.temerValueLabel.text = secondsToMinutesAndSeconds(timeInSeconds: timer.timerValue ?? 0)
        } else if cameFrom == "agitation scheme"{
            let agitation = agitationScheme[indexPath.row]
            
            cell.timerNameLabel.text = agitation.timerName
            cell.temerValueLabel.text = secondsToMinutesAndSeconds(timeInSeconds: agitation.timerValue ?? 0)
        }
        
        let selectedIndexPath = IndexPath(row: selectedTimer, section: 0)
        if let startScrollPosition = UITableViewScrollPosition(rawValue: 0) {
            tableview.selectRow(at: selectedIndexPath, animated: true, scrollPosition: startScrollPosition)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timer = timers[indexPath.row]
        let minutes = timer.timerValue! / 60
        let seconds = timer.timerValue! % 60
        
        selectedTimer = indexPath.row
        secondsCountDownPicker.selectRow(minutes, inComponent: 0, animated: true)
        secondsCountDownPicker.selectRow(seconds, inComponent: 1, animated: true)
    }
}

//MARL: Picker view digits
extension SetTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutesAndSeconds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(minutesAndSeconds[row]) \(component == 0 ? "min." : "sec.")"

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cameFrom = cameFrom else {
            fatalError()
        }
        let minutes = secondsCountDownPicker.selectedRow(inComponent: 0)
        let seconds = secondsCountDownPicker.selectedRow(inComponent: 1)
        
        if cameFrom == "set timers" {
            timers[selectedTimer].timerValue = minutes * 60 + seconds
        } else if cameFrom == "agitation scheme" {
            agitationScheme[selectedTimer].timerValue = minutes * 60 + seconds
        }
        
        setTimeTableView.reloadData()
    }
}
