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
import SwipeCellKit

class DataBaseViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Properties
    var realm: Realm!
    var selectedIndexPath: IndexPath?
    var configurations: [TimerConfig] = []
    var configurationsList: [TimerConfig] = []
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        return view
    }()
    

    //MARL: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                            target: self,
                                                            action: #selector(addNewTimer))
        
        configurationsList = PTRealmDatabase.loadConfigurationsFromDB()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        tableview.addGestureRecognizer(longpress)
        
        tableview.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableview.reloadData()
    }
    
    //MARK: Actions
    @IBAction func unwindToDataBase(sender: UIStoryboardSegue) {
        //Проверяем, что переход был осуществлен из конфигуратора
        if let sourceViewController = sender.source as? ConfiguratorViewController, let config = sourceViewController.configToSave {

            //Если редактировался таймер из БД, обновляем этот таймер
            if let selectedIndexPath = selectedIndexPath {
                
                if PTRealmDatabase.updateConfiguration(newConfig: config) {
                    configurationsList[selectedIndexPath.row] = config
                    self.tableview.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    fatalError("Save updated configuration is fail")
                }
            }
            else {
                // Add a new timer
                let newIndexPath = IndexPath(row: configurationsList.count, section: 0)
                if PTRealmDatabase.saveNewConfiguration(forConfiguration: config) {
                    configurationsList.append(config)
                    self.tableview.insertRows(at: [newIndexPath], with: .none)
                } else {
                    fatalError("Save new configuration is fail")
                }
            }
        }
    }

    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableview)//
        var indexPath = tableview.indexPathForRow(at: locationInView)
        if indexPath?.row == configurationsList.count {
            return
        }

        struct My {
            static var cellSnapshot: UIView? = nil
        }
        struct Path {
            static var initialIndexPath: IndexPath? = nil
        }

        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath!
                guard let cell = tableview.cellForRow(at: indexPath!) as UITableViewCell? else {
                    return
                }
                My.cellSnapshot  = snapshotOfCell(inputView: cell)
                var center = cell.center
                My.cellSnapshot?.center = center
                My.cellSnapshot!.alpha = 0.0
                tableview.addSubview(My.cellSnapshot!)

                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0

                }, completion: { (finished) -> Void in
                    if finished {
                        cell.isHidden = true
                    }
                })
            }

        case UIGestureRecognizerState.changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath) && (indexPath?.row != configurationsList.count)) {
                let temp = configurationsList.remove(at: (Path.initialIndexPath?.row)!)
                configurationsList.insert(temp, at: (indexPath?.row)!)
                tableview.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }

        default:
            guard let cell = tableview.cellForRow(at: Path.initialIndexPath!) as UITableViewCell? else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapshot!.removeFromSuperview()
                    My.cellSnapshot = nil
                }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as? UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    //MARK: Private method
    private func secondsToMinutesSeconds (time counter: Int) -> (String) {
        let minutes = counter / 60
        let seconds = counter % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    
}

//MARK: Table view extension
extension DataBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: ".SFUIText-Semibold", size: 37)
        headerLabel.textColor = UIColor.black
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableview.headerView(forSection: 0)?.textLabel?.font = UIFont(name: ".SFUIText-Semibold", size: CGFloat(55))
        return "Таймеры"
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //Количество ячеек в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurationsList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (configurationsList.count) {
            let configuration = configurationsList[indexPath.row]
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.dbConfigCell, for: indexPath) as? DataBaseTableViewCell else {
                fatalError("The dequeued cell is not an instance of DataBaseTableViewCell.")
            }
        
            guard let timerName = configuration.schemeName else {
                fatalError("Timer name is nil in row with index \(indexPath.row)")
            }
            cell.delegate = self
        
            cell.contentView.backgroundColor = UIColor.clear
            cell.timerNameTextLabel?.text = timerName
            cell.infoTextLabel?.text = "\(secondsToMinutesSeconds(time: configuration.devTime)) / \(secondsToMinutesSeconds(time: configuration.stopTime)) / \(secondsToMinutesSeconds(time: configuration.fixTime)) / \(secondsToMinutesSeconds(time: configuration.washTime)) / \(secondsToMinutesSeconds(time: configuration.dryTime))"
        
            let cellShadowLayer : UIView = UIView(frame: CGRect(x: 19, y: 10, width: self.view.frame.size.width - 38, height: 65))
            cellShadowLayer.layer.backgroundColor = UIColor.white.cgColor
            cellShadowLayer.layer.masksToBounds = false
            cellShadowLayer.layer.cornerRadius = 10.0
            cellShadowLayer.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cellShadowLayer.layer.shadowRadius = 7
            cellShadowLayer.layer.shadowOpacity = 0.4
        
            cell.addSubview(cellShadowLayer)
            cell.sendSubview(toBack: cellShadowLayer)
        
    //        cell.accessoryType = .disclosureIndicator
        
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.dbConstructCell, for: indexPath) as? DataBaseConstructorCell else {
                fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
            }
            
            cell.titleTextLabel.text = "Конструктор таймера"
            cell.titleTextLabel.textColor = UIColor.white
            
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.frame = CGRect(
                x: 0,
                y: 0,
                width: cell.frame.size.width - 38,
                height: 65)
            
            let startColor = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(181.0/255.0), blue: CGFloat(90.0/255.0), alpha: 1)
            let endColor = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(97.0/255.0), alpha: 1)
            backgroundGradient.colors = [startColor.cgColor, endColor.cgColor]
            backgroundGradient.cornerRadius = 10
            backgroundGradient.masksToBounds = false
            backgroundGradient.shadowOffset = CGSize(width: 0.0, height: 0.0)
            backgroundGradient.shadowRadius = 7
            backgroundGradient.shadowOpacity = 0.4
            
            let cellShadowLayer : UIView = UIView(frame: CGRect(x: 19, y: 10, width: self.view.frame.size.width - 38, height: 65))
            cellShadowLayer.layer.addSublayer(backgroundGradient)

            cell.addSubview(cellShadowLayer)
            cell.sendSubview(toBack: cellShadowLayer)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row < (configurationsList.count) {
            guard let timerVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.timerVC) as? TimerViewController else { return }
            let selectedTimer = configurationsList[indexPath.row]
            
            selectedIndexPath = indexPath
            timerVC.incomingTimer = selectedTimer
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
    
    
    //MARK: - Navigation
    func goToNavigationController(viewController: UIViewController, animated: Bool) {
        
    }
}

extension DataBaseViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        let editAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            guard let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.coonfiguratorVC) as? ConfiguratorViewController else {
                    return
                }

                self.selectedIndexPath = indexPath
                let configToBeUpdated = self.configurationsList[indexPath.row]
                destinationViewController.currentConfiguration = configToBeUpdated
                self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
        editAction.image = UIImage(named: "editAction")
        editAction.backgroundColor = UIColor.white


        let deleteAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
             //Delete the row from the data source
            let item = self.configurationsList[indexPath.row]
            if PTRealmDatabase.deleteConfiguration(forConfig: item) {
                self.configurationsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                fatalError("Delete is fail")
            }
        }
        deleteAction.image = UIImage(named: "deleteAction")
        deleteAction.backgroundColor = UIColor.white

        if orientation == .right {
            return [editAction, deleteAction]
        }
        return  nil
    }

    func visibleRect(for tableView: UITableView) -> CGRect? {
        return CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
}
