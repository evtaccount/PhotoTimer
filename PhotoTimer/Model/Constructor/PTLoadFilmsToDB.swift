//
//  PTLoadFilmsToDB.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 16/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class PTLoadFilmsToDB {
    static let jsonFilmsDB = "filmsDatabase"
    
    class func loadFilms() {
        let jsonResult = getJSON(fileName: jsonFilmsDB)
        let films = PTFilmsDataBaseInit(fromString: jsonResult)
        PTRealmDatabase.saveFilmsToDB(filmsToSave: films)
    }
    
    static func getJSON(fileName: String) -> Any? {
        var jsonResult: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                return jsonResult
            } catch {
                
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func PTFilmsDataBaseInit(fromString jsonResult: Any?) -> List<FilmRealm> {
        if let filmsList = jsonResult as? [String:[String:[[String:Any]]]] {
            var filmsToDB = List<FilmRealm>()
            
            for film in filmsList.keys {
                var developers = List<Developers>()
                guard let currentFilm = filmsList [film] else {
                    return List<FilmRealm>()
                }
                
                for developer in currentFilm.keys {
                    var devProperties = List<DevProperties>()
                    guard let devProperty = currentFilm[developer] else {
                        return List<FilmRealm>()
                    }
                    
                    for item in devProperty {
                        guard let property = DevProperties.parse(json: item) else {
                            continue
                        }
                        
                        devProperties.append(property)
                    }
                    developers.append(Developers(devName: developer, devPreferences: devProperties))
                }
                filmsToDB.append(FilmRealm(filmName: film, developers: developers))
            }
            
            return filmsToDB
        } else {
            return List<FilmRealm>()
        }
    }
}
