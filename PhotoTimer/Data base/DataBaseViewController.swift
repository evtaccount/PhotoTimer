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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var realm : Realm!
    let cellIdentifier = "dataBaseCell"
    var selectedIndexPath: IndexPath?
    var configurations: [RealmDevelop] = []
    var configurationsList: Results<RealmDevelop> {
        get {
            return realm.objects(RealmDevelop.self)
        }
    }

    //MARL: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        realm = try! Realm()
        self.tableView?.reloadData()
        // Do any additional setup after loading the view.
        
//        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
//        tableView.addGestureRecognizer(longpress)
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
                
                self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
                //Если создавался новый таймер, добавляем его в конец списка
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: configurationsList.count, section: 0)
                try! self.realm.write {
                    self.realm.add(config)
                }
                
                self.tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
//
//    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
//        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
//        let state = longPress.state
//        var locationInView = longPress.location(in: tableView)
//        var indexPath = tableView.indexPathForRow(at: locationInView)
//
//        struct My {
//            static var cellSnapshot: UIView? = nil
//        }
//        struct Path {
//            static var initialIndexPath: IndexPath? = nil
//        }
//
//        switch state {
//        case UIGestureRecognizerState.began:
//            if indexPath != nil {
//                Path.initialIndexPath = indexPath!
//                guard let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell? else {
//                    return
//                }
//                My.cellSnapshot  = snapshopOfCell(inputView: cell)
//                var center = cell.center
//                My.cellSnapshot?.center = center
//                My.cellSnapshot!.alpha = 0.0
//                tableView.addSubview(My.cellSnapshot!)
//
//                UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                    center.y = locationInView.y
//                    My.cellSnapshot!.center = center
//                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//                    My.cellSnapshot!.alpha = 0.98
//                    cell.alpha = 0.0
//
//                }, completion: { (finished) -> Void in
//                    if finished {
//                        cell.isHidden = true
//                    }
//                })
//            }
//
//        case UIGestureRecognizerState.changed:
//            var center = My.cellSnapshot!.center
//            center.y = locationInView.y
//            My.cellSnapshot!.center = center
//            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
//                swap(&configurationsList[indexPath!.row], &configurationsList[Path.initialIndexPath!.row])
//                tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
//                Path.initialIndexPath = indexPath
//            }
//
//        default:
//            guard let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell? else {
//                return
//            }
//            cell.isHidden = false
//            cell.alpha = 0.0
//            UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                My.cellSnapshot!.center = cell.center
//                My.cellSnapshot!.transform = CGAffineTransform.identity
//                My.cellSnapshot!.alpha = 0.0
//                cell.alpha = 1.0
//            }, completion: { (finished) -> Void in
//                if finished {
//                    Path.initialIndexPath = nil
//                    My.cellSnapshot!.removeFromSuperview()
//                    My.cellSnapshot = nil
//                }
//            })
//        }
//    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    //MARK: Private functions
    func load() {
        ProductsInteractor().getProducts { configurations in
            self.configurations = configurations
            
//            for item in configurations {
//                try! self.realm.write {
//                    self.realm.add(item)
//                }
//            }
//            self.tableview.reloadData()
        }
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
            
            guard let indexPath = self.tableView?.indexPath(for: selectedTimerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            selectedIndexPath = self.tableView?.indexPath(for: selectedTimerCell)
            tableView.deselectRow(at: indexPath, animated: true)
            
            let selectedTimer = configurationsList[indexPath.row]
            timerViewController.incomingTimer = selectedTimer
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
}
