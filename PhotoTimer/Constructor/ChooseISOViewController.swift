//
//  ChooseISOViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 10/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseISOViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filmName: String?
    var developerName: String?
    var choosenDeveloper: Developers?
    var devProperties = List<DevProperties>()
    let cellIdentifier = "isoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let devProperties = choosenDeveloper?.devPreferences, let filmName = filmName else {
            return
        }
        
        self.devProperties = devProperties
        self.filmName = filmName
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let timerViewController = segue.destination as? ConfiguratorViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedTimerCell = sender as? ChooseISOTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = self.tableView?.indexPath(for: selectedTimerCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let propertySet = devProperties[indexPath.row]
        guard let filmName = filmName, let developerName = choosenDeveloper?.devName else {
            return
        }
        let schemeName = filmName + "+" + developerName
        let devTime = propertySet.developingTime
        let firstAgitationDuration = propertySet.firstAgitationDuration
        let periodAgitationDuration = propertySet.periodAgitationDuration
        let agitationPeriod = propertySet.agitationPeriod
        
        let timer = TimerConfig(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
        timerViewController.currentConfiguration = timer
    }

}

extension ChooseISOViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let choosenDeveloper = choosenDeveloper else {
            return 0
        }
        return choosenDeveloper.devPreferences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let propertySet = devProperties[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChooseISOTableViewCell else {
            fatalError("The dequeued cell is not an instance of ChooseISOTableViewCell.")
        }
        
        cell.isoTextLabel.text = propertySet.iso
        cell.dilutionTextLabel.text = propertySet.dilution
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let film = filmsList[indexPath.row]
    //        let developers = film.developers
    //
    //
    //    }
    //
    //
}
