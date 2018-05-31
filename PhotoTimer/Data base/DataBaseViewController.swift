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
    var realm: Realm!
    let cellIdentifier = "dataBaseCell"
    var selectedIndexPath: IndexPath?
    var configurations: [RealmDevelop] = []
    var configurationsList: [RealmDevelop] = []
    
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
        
        loadSamplesFromDB()
        realm = try! Realm()
        self.tableview?.reloadData()
        // Do any additional setup after loading the view.
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
        tableview.addGestureRecognizer(longpress)
        
        tableview.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    //MARK: Actions
    @IBAction func unwindToDataBase(sender: UIStoryboardSegue) {
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
            else {
                // Add a new timer
                let newIndexPath = IndexPath(row: configurationsList.count, section: 0)
                try! self.realm.write {
                    self.realm.add(config)
                }
                
                configurationsList.append(config)
                self.tableview.insertRows(at: [newIndexPath], with: .none)
            }
        }
    }

    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableview)//
        var indexPath = tableview.indexPathForRow(at: locationInView)

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
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
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
    
    //MARK: Private method
    private func loadSamplesFromDB() {
        let realm = try! Realm()
        var configurations = [RealmDevelop]()
        for config in realm.objects(RealmDevelop.self) {
            configurations.append(config)
        }
        self.configurationsList = configurations
    }
    
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
        return configurationsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;
    }
    
    //Определяем содержимое ячеек
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configuration = configurationsList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DataBaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of DataBaseTableViewCell.")
        }
        
        guard let timerName = configuration.schemeName else {
            fatalError("Timer name is nil in row with index \(indexPath.row)")
        }
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.timerNameTextLabel?.text = timerName
        cell.infoTextLabel?.text = "Проявка \(secondsToMinutesSeconds(time: configuration.devTime)), стоп-раствор \(secondsToMinutesSeconds(time: configuration.stopTime)), фикс \(secondsToMinutesSeconds(time: configuration.fixTime)), промывка \(secondsToMinutesSeconds(time: configuration.washTime)), сумка \(secondsToMinutesSeconds(time: configuration.dryTime))"
        
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
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (deletAction, indexPath) in
            // Delete the row from the data source
            let item = self.configurationsList[indexPath.row]
            try! self.realm.write {
                self.realm.delete(item)
            }
            self.configurationsList.remove(at: indexPath.row)
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
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = self.tableview?.indexPath(for: selectedTimerCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            selectedIndexPath = self.tableview?.indexPath(for: selectedTimerCell)
            tableview.deselectRow(at: indexPath, animated: true)
            
            let selectedTimer = configurationsList[indexPath.row]
            timerViewController.incomingTimer = selectedTimer
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
}
