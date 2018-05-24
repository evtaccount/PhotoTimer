//
//  DataBaseViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 19/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class DataBaseViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Properties
    var realm : Realm!
    let cellIdentifier = "dataBaseCell"
    var selectedIndexPath: IndexPath?
    var configurations: [Develop] = []
    var configurationsList: Results<RealmDevelop> {
        get {
            return realm.objects(RealmDevelop.self)
        }
    }

    //MARL: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        load()
        realm = try! Realm()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        //Проверяем, что переход был осуществлен из конфигуратора
        if let sourceViewController = sender.source as? ConfiguratorViewController, let config = sourceViewController.configToSave {

            //Если редактировался таймер из БД, обновляем этот таймер
            if let selectedIndexPath = selectedIndexPath {
                try! self.realm.write {
                    configurationsList[selectedIndexPath.row].schemeName = config.schemeName
                    configurationsList[selectedIndexPath.row].filmName = config.filmName
                    configurationsList[selectedIndexPath.row].developerName = config.developerName
                    configurationsList[selectedIndexPath.row].devTime = config.devTime
                    configurationsList[selectedIndexPath.row].stopTime = config.stopTime
                    configurationsList[selectedIndexPath.row].fixTime = config.fixTime
                    configurationsList[selectedIndexPath.row].washTime = config.washTime
                    configurationsList[selectedIndexPath.row].dryTime = config.dryTime
                    configurationsList[selectedIndexPath.row].firstAgitationDuration = config.firstAgitationDuration
                    configurationsList[selectedIndexPath.row].periodAgitationDuration = config.periodAgitationDuration
                    configurationsList[selectedIndexPath.row].agitationPeriod = config.agitationPeriod
                }
                
                self.tableview.reloadRows(at: [selectedIndexPath], with: .none)
            }
                //Если создавался новый таймер, добавляем его в конец списка
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: configurationsList.count, section: 0)
                try! self.realm.write {
                    self.realm.add(config)
                }
                
                self.tableview?.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private functions
    func load() {
        ProductsInteractor().getProducts { configurations in
            self.configurations = configurations
//            self.tableview.reloadData()
        }
    }
    
    //Загрузка тестовых записей
    private func loadSampleTimers() {
        
//        let timer1 = Develop(schemeName: "Таймер 1", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
//
//        let timer2 = Develop(schemeName: "Таймер 2", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 24, dryTime: 20, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
//
//        let timer3 = Develop(schemeName: "Таймер 3", filmName: "Fomapan 400", developerName: "Ilford", devTime: 10*60, stopTime: 1*60, fixTime: 1*60, washTime: 35, dryTime: 30, firstAgitationDuration: 60, periodAgitationDuration: 60, agitationPeriod: 8)
//
//        configurations += [timer1, timer2, timer3]
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
        return configurationsList.count
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configuration = configurationsList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DataBaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        guard let timerName = configuration.schemeName else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        cell.timerNameTextLabel?.text = timerName
        
        return cell
    }
    
//    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            let item = configurationsList[indexPath.row]
//            try! self.realm .write {
//                self.realm.delete(item)
//            }
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (deletAction, indexPath) in
            // Delete the row from the data source
            let item = self.configurationsList[indexPath.row]
            try! self.realm .write {
                self.realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) in
            guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "configuratorViewController") as? ConfiguratorViewController else {
                return
            }
            
            self.selectedIndexPath = indexPath
            let listToBeUpdated = self.configurationsList[indexPath.row]
            destinationViewController.currentConfiguration = listToBeUpdated
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        }
        
        return [deletAction, editAction]
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
            tableview.deselectRow(at: indexPath, animated: true)
            
            let selectedTimer = configurationsList[indexPath.row]
            timerViewController.incomingTimer = selectedTimer
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
}
