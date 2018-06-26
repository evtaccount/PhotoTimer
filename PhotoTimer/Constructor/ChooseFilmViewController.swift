//
//  ConstructorViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseFilmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filmsList: [Film] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        filmsList = PTRealmDatabase.loadFilmsFormDB()
        // Do any additional setup after loading the view.
    }

    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let chooseDeveloperViewController = segue.destination as? ChooseDeveloperViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedFilmCell = sender as? ChooseFilmTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = self.tableView?.indexPath(for: selectedFilmCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let film = filmsList[indexPath.row]
        chooseDeveloperViewController.choosenFilm = film
    }
}

extension ChooseFilmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = filmsList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.constructFilmCell, for: indexPath) as? ChooseFilmTableViewCell else {
            fatalError("The dequeued cell is not an instance of ConstructorTableViewCell.")
        }
        
        cell.filmNameTextLabel.text = film.filmName
        
        return cell
    }
}