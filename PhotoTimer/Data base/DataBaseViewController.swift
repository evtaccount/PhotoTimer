//
//  DataBaseViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 19/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import os.log

class DataBaseViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var configurations: [Develop] = []
    let cellIdentifier = "dataBaseCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTimers()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ConfiguratorViewController, let config = sourceViewController.configToSave {
            let newIndexPath = IndexPath(row: configurations.count, section: 0)
            
            if let selectedIndexPath = self.tableview.indexPathForSelectedRow {
                // Update an existing meal.
                configurations[selectedIndexPath.row] = config
                self.tableview.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                configurations.append(config)
//                self.tableview?.reloadData()
                self.tableview?.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            
        }
    }
    
    private func loadSampleTimers() {
        
        let timer1 = Develop(schemeName: "Таймер 1", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
        let timer2 = Develop(schemeName: "Таймер 2", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 24, dryTime: 20, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
//        let timer3 = Develop(schemeName: "Таймер 3", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
        configurations += [timer1, timer2]
    }

}

//MARK: Table view extension
extension DataBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurations.count
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configuration = configurations[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DataBaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        guard let timerName = configuration.schemeName else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.timerNameTextLabel?.text = timerName
        
        return cell
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addTimer":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "showTimer":
            guard let timerViewController = segue.destination as? TimerViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTimerCell = sender as? DataBaseTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = self.tableview?.indexPath(for: selectedTimerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTimer = configurations[indexPath.row]
            timerViewController.incomingTimer = selectedTimer
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
//    //Навигация до соответствующих экранов
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let destinationViewController: UIViewController
//
//
//        self.navigationController?.pushViewController(destinationViewController, animated: true)
//    }
    
}
