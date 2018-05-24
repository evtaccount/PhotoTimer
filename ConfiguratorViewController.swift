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
    var currentConfiguration: RealmDevelop?
    var configToSave: RealmDevelop?
    let cellIdentifier = "timerConfigCell"
    var menu: [ItemList] = []
    var selectedIndexPath: IndexPath?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = currentConfiguration {
            setup()
        } else {
            currentConfiguration = RealmDevelop(schemeName: "", filmName: "", developerName: "")
            saveButton.isEnabled = false
            selectedIndexPath = nil
            setup()
        }
        // Do any additional setup after loading the view.
    }

    //MARK: Pritate methods
    private func setup() {
        
        menu = [
            ItemList(itemName: "timerName", imageName: "configIcon", itemValue: currentConfiguration?.schemeName),
            ItemList(itemName: "filmName", imageName: "filmIcon", itemValue: currentConfiguration?.filmName),
            ItemList(itemName: "developerName", imageName: "developerIcon", itemValue: currentConfiguration?.developerName),
            ItemList(itemName: "timers", imageName: "timersIcon", itemValue: "Timers"),
            ItemList(itemName: "agitationScheme", imageName: "timersIcon", itemValue: "Agitation scheme")
        ]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        guard let schemeName = currentConfiguration?.schemeName,
              let filmName = currentConfiguration?.filmName,
              let developerName = currentConfiguration?.developerName,
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
        
        configToSave = RealmDevelop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let fromEditNameViewController = sender.source as? EditNameViewController, let item = fromEditNameViewController.newNameValue {
            
            switch item.itemName {
            case "timerName":
                menu[0].itemValue = item.itemValue
                currentConfiguration?.schemeName = item.itemValue!
                
            case "filmName":
                menu[1].itemValue = item.itemValue
                currentConfiguration?.filmName = item.itemValue
                
            case "developerName":
                menu[2].itemValue = item.itemValue
                currentConfiguration?.developerName = item.itemValue
                
            default:
                 os_log("Unknown item name", log: OSLog.default, type: .debug)
            }
            
            self.tableview.reloadData()
        } else if let fromSetTimeViewController = sender.source as? SetTimeViewController {
            
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
                fatalError("Unknown flag")
            }
            
        }
        
        if let schemeName = currentConfiguration?.schemeName, let filmName = currentConfiguration?.filmName, let developerName = currentConfiguration?.developerName {
            if !schemeName.isEmpty && !filmName.isEmpty && !developerName.isEmpty {
                saveButton.isEnabled = true
            }
        }
    }
    
    @IBAction func cancelButtonPressedAction(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
}

//MARK: Table view extension
extension ConfiguratorViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemOfMenu = menu[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConfiguratorTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.itemImageView.image = UIImage(named: itemOfMenu.imageName)
        cell.itemTextLabel.text = itemOfMenu.itemValue ?? ""
        
        return cell
    }
    
    //Навигация до соответствующих экранов
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController: UIViewController
        
        switch indexPath.row {
        case 0, 1, 2:
            guard let editNameViewController = self.storyboard?.instantiateViewController(withIdentifier: "editNameViewController") as? EditNameViewController else {
                return
            }
            let item = menu[indexPath.row]
            
            editNameViewController.recievedNameValue = item
            destinationViewController = editNameViewController
            
        case 3:
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
            
        case 4:
            guard let setTimersViewController = self.storyboard?.instantiateViewController(withIdentifier: "setTimerViewController") as? SetTimeViewController else {
                return
            }
            setTimersViewController.agitationScheme[0].timerValue = currentConfiguration?.firstAgitationDuration
            setTimersViewController.agitationScheme[1].timerValue = currentConfiguration?.agitationPeriod
            setTimersViewController.agitationScheme[2].timerValue = currentConfiguration?.periodAgitationDuration
            setTimersViewController.cameFrom = "agitation scheme"
            destinationViewController = setTimersViewController
        default:
            return
        }

        tableview.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
}
