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

    //MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Properties
    var configurations: [Develop] = []
    let cellIdentifier = "dataBaseCell"
    public var selectedIndexPath: IndexPath?

    //MARL: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleTimers()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
    }

    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    
        
        //Проверяем, что переход был осуществлен из конфигуратора
        if let sourceViewController = sender.source as? ConfiguratorViewController, let config = sourceViewController.configToSave {

            //Если редактировался таймер из БД, обновляем этот таймер
            if let selectedIndexPath = selectedIndexPath {
                configurations[selectedIndexPath.row] = config
                self.tableview.reloadRows(at: [selectedIndexPath], with: .none)
            }
                //Если создавался новый таймер, добавляем его в конец списка
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: configurations.count, section: 0)
                configurations.append(config)
                self.tableview?.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private functions
    
    //Загрузка тестовых записей
    private func loadSampleTimers() {
        
        let timer1 = Develop(schemeName: "Таймер 1", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
        let timer2 = Develop(schemeName: "Таймер 2", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 24, dryTime: 20, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
        let timer3 = Develop(schemeName: "Таймер 3", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
        
        configurations += [timer1, timer2, timer3]
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
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            configurations.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: - Navigation
    
    //Небольшая подготовка перед переходом к другому VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addTimer":
            selectedIndexPath = nil
            os_log("Adding a new timer.", log: OSLog.default, type: .debug)
            
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
            
            selectedIndexPath = self.tableview?.indexPath(for: selectedTimerCell)
            
            let selectedTimer = configurations[indexPath.row]
            timerViewController.incomingTimer = selectedTimer
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
}
