//
//  ConfiguratorViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 15/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import os.log

class ConfiguratorViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: Properties
    var currentConfiguration: TimerConfig?
    var configToSave: TimerConfig?
    var menuNames: [[ItemList]] = []
    var selectedIndexPath: IndexPath?
    var fromTimer: Bool = false
    let placeholders = ["Название таймера", "Навание пленки", "Название проявителя"]
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false

        if currentConfiguration != nil {
            setup()
            fromTimer = true
        } else {
            currentConfiguration = TimerConfig(schemeName: nil, filmName: nil, developerName: nil)
            saveButton.isEnabled = false
            selectedIndexPath = nil
            setup()
        }
        
//        tableview.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
    }

    //MARK: Pritate methods
    private func setup() {
        
        menuNames = [[
            ItemList(itemName: "timerName", imageName: "configIcon", itemValue: currentConfiguration?.schemeName),
            ItemList(itemName: "filmName", imageName: "filmIcon", itemValue: currentConfiguration?.filmName),
            ItemList(itemName: "developerName", imageName: "developerIcon", itemValue: currentConfiguration?.developerName)
        ],[
            ItemList(itemName: "timers", imageName: "timersIcon", itemValue: "Настроить таймеры"),
            ItemList(itemName: "agitationScheme", imageName: "timersIcon", itemValue: "Настроить перемешивание")
            ]
        ]
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = true
        
        for ind in 0...2 {
            let indexPath = IndexPath(row: ind, section: 0)
            let cell = self.tableview.cellForRow(at: indexPath) as! ConfiguratorTextFieldCell
            
            guard let name = cell.itemTextField.text else {
                return
            }
            
            saveButton.isEnabled = !name.isEmpty && saveButton.isEnabled
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }

        for ind in 0...2 {
            let indexPath = IndexPath(row: ind, section: 0)
            let cell = self.tableview.cellForRow(at: indexPath) as! ConfiguratorTextFieldCell

            guard let name = cell.itemTextField.text else {
                return
            }
            menuNames[0][ind].itemValue = name
        }

//        currentConfiguration?.schemeName = menuNames[0][0].itemValue
//        currentConfiguration?.filmName = menuNames[0][1].itemValue
//        currentConfiguration?.developerName = menuNames[0][2].itemValue

        guard let id = currentConfiguration?.id,
              let schemeName = menuNames[0][0].itemValue,
              let filmName = menuNames[0][1].itemValue,
              let developerName = menuNames[0][2].itemValue,
              let devTime = currentConfiguration?.devTime,
              let stopTime = currentConfiguration?.stopTime,
              let fixTime = currentConfiguration?.fixTime,
              let washTime = currentConfiguration?.washTime,
              let dryTime = currentConfiguration?.washTime,
              let firstAgitationDuration = currentConfiguration?.firstAgitationDuration,
              let periodAgitationDuration = currentConfiguration?.periodAgitationDuration,
              let agitationPeriod = currentConfiguration?.agitationPeriod else {
            return
        }

//        configToSave?.id = id
        
        configToSave = TimerConfig(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
    
    //MARK: Actions
    @IBAction func unwindToConfigurator(sender: UIStoryboardSegue) {
        if let fromSetTimeViewController = sender.source as? SetTimeViewController {
            if fromSetTimeViewController.cameFrom == "set timers" {
                let timers = fromSetTimeViewController.timers
                currentConfiguration?.devTime = (timers[0].timerValue)!
                currentConfiguration?.stopTime = (timers[1].timerValue)!
                currentConfiguration?.fixTime = (timers[2].timerValue)!
                currentConfiguration?.washTime = (timers[3].timerValue)!
                currentConfiguration?.dryTime = (timers[4].timerValue)!
            } else if fromSetTimeViewController.cameFrom == "agitation scheme" {
                let agitation = fromSetTimeViewController.agitationScheme
                currentConfiguration?.firstAgitationDuration = agitation[0].timerValue!
                currentConfiguration?.agitationPeriod = agitation[1].timerValue!
                currentConfiguration?.periodAgitationDuration = agitation[2].timerValue!
            } else {
                fatalError("UnwindToConfiguratorViewController. Unknown flag")
            }
        }
        
        if let schemeName = currentConfiguration?.schemeName, let filmName = currentConfiguration?.filmName, let developerName = currentConfiguration?.developerName {
            if !schemeName.isEmpty && !filmName.isEmpty && !developerName.isEmpty {
                saveButton.isEnabled = true
            }
        }
    }
    
    @IBAction func saveButtonPressedAction(_ sender: UIBarButtonItem) {
        guard let dataBaseVC = storyboard?.instantiateViewController(withIdentifier: "dataBaseVC") else { return }
        
        for ind in 0...2 {
            let indexPath = IndexPath(row: ind, section: 0)
            let cell = self.tableview.cellForRow(at: indexPath) as! ConfiguratorTextFieldCell
            
            guard let name = cell.itemTextField.text else {
                return
            }
            menuNames[0][ind].itemValue = name
        }
        
        let idd = currentConfiguration?.id
        guard let id = currentConfiguration?.id,
              let schemeName = menuNames[0][0].itemValue,
              let filmName = menuNames[0][1].itemValue,
              let developerName = menuNames[0][2].itemValue,
              let devTime = currentConfiguration?.devTime,
              let stopTime = currentConfiguration?.stopTime,
              let fixTime = currentConfiguration?.fixTime,
              let washTime = currentConfiguration?.washTime,
              let dryTime = currentConfiguration?.washTime,
              let firstAgitationDuration = currentConfiguration?.firstAgitationDuration,
              let periodAgitationDuration = currentConfiguration?.periodAgitationDuration,
              let agitationPeriod = currentConfiguration?.agitationPeriod else {
                  return
        }
        
        let configToSave = TimerConfig.init()
        configToSave.id = id
        configToSave.schemeName = schemeName
        configToSave.filmName = filmName
        configToSave.developerName = developerName
        configToSave.devTime = devTime
        configToSave.stopTime = stopTime
        configToSave.fixTime = fixTime
        configToSave.washTime = washTime
        configToSave.dryTime = dryTime
        configToSave.firstAgitationDuration = firstAgitationDuration
        configToSave.periodAgitationDuration = periodAgitationDuration
        configToSave.agitationPeriod = agitationPeriod
        
//        let configToSave = TimerConfig(id: id, schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        
        if fromTimer {
            let result = PTRealmDatabase.updateConfiguration(newConfig: configToSave)
            print(result)
        } else {
            let result = PTRealmDatabase.saveNewConfiguration(forConfiguration: configToSave)
            print(result)
        }
        
        navigationController?.pushViewController(dataBaseVC, animated: true)
    }
    
    @IBAction func cancelButtonPressedAction(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddTimerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTimerMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ConfiguratorViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
}

//MARK: Table view extension
extension ConfiguratorViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return " "
        
    }
    
    //Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        switch section {
        case 0:
            return menuNames[section].count
        case 1:
            return menuNames[section].count
        default:
            fatalError()
        }
        return numberOfRows
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemOfMenu = menuNames[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.configTextField, for: indexPath) as? ConfiguratorTextFieldCell else {
                fatalError("The dequeued cell is not an instance of ConfiguratorLabelTableViewCell.")
            }
            cell.newImageView.image = UIImage(named: itemOfMenu.imageName)
            if let text = itemOfMenu.itemValue {
                cell.itemTextField.text = text
            } else {
                cell.itemTextField.placeholder = placeholders[indexPath.row]
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.configSetTimer, for: indexPath) as? ConfiguratorLabelTableViewCell else {
                fatalError("The dequeued cell is not an instance of ConfiguratorLabelTableViewCell.")
            }
            cell.itemImageView.image = UIImage(named: itemOfMenu.imageName)
            cell.itemTextLabel.text = itemOfMenu.itemValue ?? ""
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
//        switch indexPath.row {
//        case 0...2:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as? ConfiguratorTextFieldCell else {
//                fatalError("The dequeued cell is not an instance of ConfiguratorLabelTableViewCell.")
//            }
//            cell.newImageView.image = UIImage(named: itemOfMenu.imageName)
//            cell.itemTextField.text = itemOfMenu.itemValue ?? ""
//
//            return cell
//
//        default:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellSetTimerIdentifier, for: indexPath) as? ConfiguratorLabelTableViewCell else {
//                fatalError("The dequeued cell is not an instance of ConfiguratorLabelTableViewCell.")
//            }
//            cell.itemImageView.image = UIImage(named: itemOfMenu.imageName)
//            cell.itemTextLabel.text = itemOfMenu.itemValue ?? ""
//
//            return cell
//        }
    }
    
    //Навигация до соответствующих экранов
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        let destinationViewController: UIViewController
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                guard let setTimersViewController = self.storyboard?.instantiateViewController(withIdentifier: "setTimerViewController") as? SetTimeViewController else {
                    return
                }
                setTimersViewController.timers[0].timerValue = currentConfiguration?.devTime
                setTimersViewController.timers[1].timerValue = currentConfiguration?.stopTime
                setTimersViewController.timers[2].timerValue = currentConfiguration?.fixTime
                setTimersViewController.timers[3].timerValue = currentConfiguration?.washTime
                setTimersViewController.timers[4].timerValue = currentConfiguration?.dryTime
                setTimersViewController.cameFrom = "set timers"
                destinationViewController = setTimersViewController
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            case 1:
                guard let setTimersViewController = self.storyboard?.instantiateViewController(withIdentifier: "setTimerViewController") as? SetTimeViewController else {
                    return
                }
                setTimersViewController.agitationScheme[0].timerValue = currentConfiguration?.firstAgitationDuration
                setTimersViewController.agitationScheme[1].timerValue = currentConfiguration?.agitationPeriod
                setTimersViewController.agitationScheme[2].timerValue = currentConfiguration?.periodAgitationDuration
                setTimersViewController.cameFrom = "agitation scheme"
                destinationViewController = setTimersViewController
                self.navigationController?.pushViewController(destinationViewController, animated: true)
                
            default:
                return
            }
        }
    }
}
