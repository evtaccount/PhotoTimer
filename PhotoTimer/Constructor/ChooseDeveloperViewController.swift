//
//  ChooseDeveloperViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 10/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseDeveloperViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var choosenFilm: Film?
    var filmName: String?
    var developers = List<Developers>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let developers = choosenFilm?.developers, let filmName = choosenFilm?.filmName else {
            return
        }

        self.developers = developers
        self.filmName = filmName
        // Do any additional setup after loading the view.
    }

    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let chooseISOViewController = segue.destination as? ChooseISOViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedFilmCell = sender as? ChooseDeveloperTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = self.tableView?.indexPath(for: selectedFilmCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let developer = developers[indexPath.row]
        chooseISOViewController.choosenDeveloper = developer
        chooseISOViewController.filmName = filmName
    }


}

extension ChooseDeveloperViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let choosenFilm = choosenFilm else {
            return 0
        }
        return choosenFilm.developers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let developer = developers[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.constructDevCell, for: indexPath) as? ChooseDeveloperTableViewCell else {
            fatalError("The dequeued cell is not an instance of ChooseDeveloperTableViewCell.")
        }

        cell.developerNameTextLabel.text = developer.devName

        return cell
    }
}
