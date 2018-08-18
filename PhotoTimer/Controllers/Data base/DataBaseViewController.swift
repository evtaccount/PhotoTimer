//
//  DataBaseViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 19/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class DataBaseViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var realm: Realm!
    var selectedIndexPath: IndexPath?
    var configurations: [TimerConfig] = []
    var configurationsList: [TimerConfig] = []
    
    //MARL: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationsList = PTRealmDatabase.loadConfigurationsFromDB()
        self.tableView?.reloadData()
    }
    
    func configureUI() {
        self.navigationController?.makeNavigationBarTransparent()
    }
    
    // MARK: - Navigation
    func goToNavigationController(viewController: UIViewController, animated: Bool) {
        
    }
}

// MARK: Table view extension
extension DataBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurationsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (configurationsList.count) {
            let configuration = configurationsList[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.dbConfigCell, for: indexPath) as? DataBaseTimerCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(with: configuration)
//            cell.delegate = self
            
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.dbConstructCell, for: indexPath) as? DataBaseButtonCell else {
                fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row < (configurationsList.count) {
            guard let timerVC = storyboard?.instantiateViewController(withIdentifier: "timerVC") as? TimerVC else { return }
            let selectedTimer = configurationsList[indexPath.row]
            
            selectedIndexPath = indexPath
            timerVC.timeProcessCounter = selectedTimer
            navigationController?.pushViewController(timerVC, animated: true)
        } else {
            guard let constructorVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.constructorVC) as? ConstructorVC else { return }
            
            constructorVC.stepID = "film"
            navigationController?.pushViewController(constructorVC, animated: true)
        }
    }
    
    @objc func addNewTimer() {
        guard let constructorVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.constructorVC) else { return }
        let vcWithNavBar = UINavigationController(rootViewController: constructorVC)
        present(vcWithNavBar, animated: true, completion: nil)
        //        navigationController?.pushViewController(constructorVC, animated: true)
        selectedIndexPath = nil
    }
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let deleteAction = UIContextualAction(style: .normal, title: nil, handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
    //            let item = self.configurationsList[indexPath.row]
    //            if PTRealmDatabase.deleteConfiguration(forConfig: item) {
    //                self.configurationsList.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //
    //                success(true)
    //            }
    //        })
    //        deleteAction.image = UIImage(named: "deleteAction")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    //        deleteAction.backgroundColor = UIColor.lightGray
    //
    //        let editAction = UIContextualAction(style: .normal, title:  nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
    //            guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "configuratorViewController") as? ConfiguratorViewController else {
    //                return
    //            }
    //
    //            self.selectedIndexPath = indexPath
    //            let listToBeUpdated = self.configurationsList[indexPath.row]
    //            destinationViewController.currentConfiguration = listToBeUpdated
    //            self.navigationController?.pushViewController(destinationViewController, animated: true)
    //            success(true)
    //        })
    //        editAction.image = UIImage(named: "editAction")
    //        editAction.backgroundColor = UIColor.lightGray
    //
    //        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    //
    //        return swipeConfig
    //    }
    
    
}

// MARK: - Actions
extension DataBaseViewController {
    @IBAction func addButtonPressedAction(_ sender: UIBarButtonItem) {
        guard let configuratorViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.coonfiguratorVC) else {
            return
        }
        self.navigationController?.pushViewController(configuratorViewController, animated: true)
    }
    
    @IBAction func unwindToDataBase(sender: UIStoryboardSegue) {
        //Проверяем, что переход был осуществлен из конфигуратора
        if let sourceViewController = sender.source as? ConfiguratorViewController, let config = sourceViewController.configToSave {
            
            //Если редактировался таймер из БД, обновляем этот таймер
            if let selectedIndexPath = selectedIndexPath {
                
                if PTRealmDatabase.updateConfiguration(newConfig: config) {
                    configurationsList[selectedIndexPath.row] = config
                    self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    fatalError("Save updated configuration is fail")
                }
            } else {
                // Add a new timer
                let newIndexPath = IndexPath(row: configurationsList.count, section: 0)
                if PTRealmDatabase.saveNewConfiguration(forConfiguration: config) {
                    configurationsList.append(config)
                    self.tableView.insertRows(at: [newIndexPath], with: .none)
                } else {
                    fatalError("Save new configuration is fail")
                }
            }
        }
    }
}

//extension DataBaseViewController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        let editAction = SwipeAction(style: .default, title: nil) { (_, indexPath) in
//            guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.coonfiguratorVC) as? ConfiguratorViewController else {
//                return
//            }
//
//            self.selectedIndexPath = indexPath
//            let configToBeUpdated = self.configurationsList[indexPath.row]
//            destinationViewController.currentConfiguration = configToBeUpdated
//            self.navigationController?.pushViewController(destinationViewController, animated: true)
//        }
//        editAction.image = UIImage(named: "editAction")
//        editAction.backgroundColor = UIColor.white
//
//        let deleteAction = SwipeAction(style: .default, title: nil) { (_, indexPath) in
//            //Delete the row from the data source
//            let item = self.configurationsList[indexPath.row]
//            if PTRealmDatabase.deleteConfiguration(forConfig: item) {
//                self.configurationsList.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                fatalError("Delete is fail")
//            }
//        }
//        deleteAction.image = UIImage(named: "deleteAction")
//        deleteAction.backgroundColor = UIColor.white
//
//        if orientation == .right {
//            return [editAction, deleteAction]
//        }
//        return  nil
//    }
//
//    func visibleRect(for tableView: UITableView) -> CGRect? {
//        return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//    }
//}
