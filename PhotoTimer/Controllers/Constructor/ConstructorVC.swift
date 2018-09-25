//
//  ConstructorViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift

class ConstructorVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stepID: String?
    var filmsList: [FilmRealm] = []
    var choosenFilm: FilmRealm?
    var filmName: String?
    var developers = List<Developers>()
    var choosenDeveloper: Developers?
    var devProperties = List<DevProperties>()
    var itemsList: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let stepID = stepID else { return }
        
        switch stepID {
        case "film":
            itemsList = PTRealmDatabase.loadFilmsFormDB() as [FilmRealm]
            
        case "developer":
            guard let developers = choosenFilm?.developers, let filmName = choosenFilm?.filmName else {
                return
            }
            
            for item in developers {
                itemsList.append(item)
            }
            self.filmName = filmName
            
        case "iso":
            guard let properties = choosenDeveloper?.devPreferences, let filmName = filmName else {
                return
            }
            
            properties.forEach { (property) in
                itemsList.append(property)
            }
            self.filmName = filmName
            
        default:
            print("iso")
        }
    }

    

    
    // MARK: - Navigation


}

extension ConstructorVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.init()
        
        if let stepID = stepID {
            switch stepID {
            case "film":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.constructFilmCell, for: indexPath) as? ConstructorFilmDevCell else {
                    fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
                }
                guard let film = itemsList[indexPath.row] as? FilmRealm else { return cell }
                cell.filmNameTextLabel.text = film.filmName
                return cell
                
            case "developer":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.constructFilmCell, for: indexPath) as? ConstructorFilmDevCell else {
                    fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
                }
                guard let developer = itemsList[indexPath.row] as? Developers else { return cell }
                cell.filmNameTextLabel.text = developer.devName
                return cell
                
            case "iso":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.constructISOCell, for: indexPath) as? ConstructorISOCell else {
                    fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
                }
                guard let propertySet = itemsList[indexPath.row] as? DevProperties else { return cell }
//                guard let iso = propertySet.iso, let dilution = propertySet.dilution else { return cell }
                let iso = propertySet.iso as String
                let dilution = propertySet.dilution as String
                cell.isoTextLabel.text = iso
                cell.dilutionTextLabel.text = dilution
                return cell
                
            default:
                fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController
        guard let stepID = stepID else { return }
        
        switch stepID {
        case "film":
            guard let filmDevVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.constructorVC) as? ConstructorVC else { return }
            let film = itemsList[indexPath.row] as? FilmRealm
            filmDevVC.choosenFilm = film
            filmDevVC.stepID = "developer"
            
            vc = filmDevVC
            
        case "developer":
            guard let filmDevVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.constructorVC) as? ConstructorVC else { return }
            let developer = itemsList[indexPath.row] as? Developers
            filmDevVC.choosenDeveloper = developer
            filmDevVC.filmName = filmName
            filmDevVC.stepID = "iso"
            
            vc = filmDevVC
            
        case "iso":
            guard let configVC = storyboard?.instantiateViewController(withIdentifier: ViewControllers.coonfiguratorVC) as? ConfiguratorViewController else { return }
            guard let filmName = filmName, let developerName = choosenDeveloper?.devName else { return }
            guard let propertySet = itemsList[indexPath.row] as? DevProperties else { return }
            
            let schemeName = filmName + "+" + developerName
            let devTime = propertySet.developingTime
            let firstAgitationDuration = propertySet.firstAgitationDuration
            let periodAgitationDuration = propertySet.periodAgitationDuration
            let agitationPeriod = propertySet.agitationPeriod
            
            let timer = TimerConfig(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
            configVC.currentConfiguration = timer
            configVC.fromConstructor = true
            
            vc = configVC
            
        default:
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
