//
//  FilmsAndDevsModelDB.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 07/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class Film: Object {
    @objc dynamic var filmName: String?
    let developers = List<Developers>()
    
    convenience init (filmName: String, developers: List<Developers>) {
        self.init()
        
        self.filmName = filmName
        for item in developers {
            self.developers.append(item)
        }
    }
}

class Developers: Object {
    @objc dynamic var devName: String?
    let devPreferences = List<DevProperties>()
    
    convenience init(devName: String, devPreferences: List<DevProperties>) {
        self.init()
        
        self.devName = devName
        for item in devPreferences {
            self.devPreferences.append(item)
        }
    }
}

class DevProperties: Object {
    @objc dynamic var iso: String = ""
    @objc dynamic var dilution: String = ""
    @objc dynamic var developingTime: Int = 0
    @objc dynamic var firstAgitationDuration: Int = 0
    @objc dynamic var periodAgitationDuration: Int = 0
    @objc dynamic var agitationPeriod: Int = 0
    
    convenience init(iso: String, dilution: String, developingTime: Int, firstAgitationDuration: Int, periodAgitationDuration: Int, agitationPeriod: Int) {
        self.init()
        
        self.iso = iso
        self.dilution = dilution
        
        self.developingTime = developingTime
        
        self.firstAgitationDuration = firstAgitationDuration
        self.periodAgitationDuration = periodAgitationDuration
        self.agitationPeriod = agitationPeriod
    }
    
    static func parseToDB(json: Dictionary<String, Any>) -> DevProperties? {
        guard let iso = json["ISO"] as? String,
            let dilution = json["dilution"] as? String,
            let devTime = json["developingTime"] as? Int,
            let firstAgitationDuration = json["firstAgitationDuration"] as? Int,
            let periodAgitationDuration = json["periodAgitationDuration"] as? Int,
            let agitationPeriod = json["agitationPeriod"] as? Int else {
                return nil
        }
        
        return DevProperties(iso: iso, dilution: dilution, developingTime: devTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
}

class Films {
    let films = [
        "AgfaPhoto APX 100 Professional": [
            "Rodinal": [
                ["ISO": "100", "dilution": "1+25", "developingTime": 480, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+50", "developingTime": 1020, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD ID-11": [
                ["ISO": "100", "dilution": "stock", "developingTime": 540, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 780, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD MICROPHEN": [
                ["ISO": "100", "dilution": "stock", "developingTime": 540, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD PERCEPTOL": [
                ["ISO": "50", "dilution": "stock", "developingTime": 540, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]]
        ],
        "AgfaPhoto APX 400 Professional": [
            "Rodinal": [
                ["ISO": "400", "dilution": "1+25", "developingTime": 300, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+50", "developingTime": 1800, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD ID-11": [
                ["ISO": "400", "dilution": "stock", "developingTime": 600, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1:1", "developingTime": 670, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1:3", "developingTime": 1500, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD MICROPHEN": [
                ["ISO": "400", "dilution": "stock", "developingTime": 630, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1:1", "developingTime": 540, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1:3", "developingTime": 1620, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD PERCEPTOL": [
                ["ISO": "320", "dilution": "stock", "developingTime": 640, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "320", "dilution": "1:1", "developingTime": 1020, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "320", "dilution": "1:3", "developingTime": 1440, "firstAgitationDuration": 60, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ],
        "Arista EDU Ultra 100": [
            "ARISTA 76 POWDER": [
                ["ISO": "100", "dilution": "stock", "developinTime": 390, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 540, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ARISTA PREMIUM POWDER": [
                ["ISO": "100", "dilution": "stock", "developingTime": 360, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 420, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "MARATHON FILM DEVELOPER": [
                ["ISO": "100", "dilution": "1+9", "developingTime": 360, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD ID-11": [
                ["ISO": "100", "dilution": "stock", "developingTime": 390, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 540, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK D-76": [
                ["ISO": "100", "dilution": "stock", "developingTime": 390, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 540, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK XTOL": [
                ["ISO": "100", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK TMAX": [
                ["ISO": "100", "dilution": "1+4", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "AGFA RODINAL": [
                ["ISO": "100", "dilution": "1+25", "developingTime": 210, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ],
        "Arista EDU Ultra 200": [
            "ARISTA 76 POWDER": [
                ["ISO": "200", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 510, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ARISTA PREMIUM POWDER": [
                ["ISO": "200", "dilution": "stock", "developingTime": 420, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "DdevelopingTime": 560, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "MARATHON FILM DEVELOPER": [
                ["ISO": "200", "dilution": "1+9", "developingTime": 300, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD ID-11": [
                ["ISO": "200", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 510, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK D-76": [
                ["ISO": "200", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 510, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK XTOL": [
                ["ISO": "200", "dilution": "stock", "developingTime": 360, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK TMAX": [
                ["ISO": "200", "dilution": "1+4", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "AGFA RODINAL": [
                ["ISO": "200", "dilution": "1+25", "developingTime": 300, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ],
        "Arista EDU Ultra 400": [
            "ARISTA 76 POWDER": [
                ["ISO": "400", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 750, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ARISTA PREMIUM POWDER": [
                ["ISO": "400", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+1", "developingTime": 510, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "MARATHON FILM DEVELOPER": [
                ["ISO": "400", "dilution": "1+9", "developingTime": 390, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "ILFORD ID-11": [
                ["ISO": "400", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+1", "developingTime": 750, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK D-76": [
                ["ISO": "400", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+1", "developingTime": 750, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK XTOL": [
                ["ISO": "400", "dilution": "stock", "developingTime": 420, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "KODAK TMAX": [
                ["ISO": "400", "dilution": "1+4", "developingTime": 390, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ],
            "AGFA RODINAL": [
                ["ISO": "400", "dilution": "1+25", "developingTime": 330, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ],
        "Fomapan 100 Classic": [
            "Fomadon LQN": [
                ["ISO": "100", "dilution": "1+10", "developingTime": 450, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon LQR": [
                ["ISO": "100", "dilution": "1+10", "developingTime": 330, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Foma universal developer": [
                ["ISO": "100", "dilution": "stock", "developingTime": 300, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon R09": [
                ["ISO": "100", "dilution": "1+25", "developingTime": 240, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10],
                ["ISO": "100", "dilution": "1:50", "developingTime": 540, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon P": [
                ["ISO": "100", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon EXCEL": [
                ["ISO": "100", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ]
        ],
        "Fomapan 200 Creative": [
            "Fomadon LQN": [
                ["ISO": "200", "dilution": "1+10", "developingTime": 330, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon LQR": [
                ["ISO": "200", "dilution": "1+10", "developingTime": 330, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Foma universal developer": [
                ["ISO": "200", "dilution": "stock", "developingTime": 210, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon R09": [
                ["ISO": "200", "dilution": "1+25", "developingTime": 300, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10],
                ["ISO": "200", "dilution": "1:50", "developingTime": 600, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon P": [
                ["ISO": "200", "dilution": "stock", "developingTime": 330, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon EXCEL": [
                ["ISO": "200", "dilution": "stock", "developingTime": 390, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ]
        ],
        "Fomapan 400 Action": [
            "Fomadon LQN": [
                ["ISO": "400", "dilution": "1+10", "developingTime": 570, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon LQR": [
                ["ISO": "400", "dilution": "1+10", "developingTime": 450, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Foma universal developer": [
                ["ISO": "400", "dilution": "stock", "developingTime": 450, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon R09": [
                ["ISO": "400", "dilution": "1+25", "developingTime": 360, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10],
                ["ISO": "400", "dilution": "1:50", "developingTime": 690, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon P": [
                ["ISO": "400", "dilution": "stock", "developingTime": 630, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ],
            "Fomadon EXCEL": [
                ["ISO": "400", "dilution": "stock", "developingTime": 420, "firstAgitationDuration": 60, "periodAgitationDuration": 60, "agitationPeriod": 10]
            ]
        ],
        "ILFORD DELTA 100 Professional": [
            "Kodak XTOL": [
                ["ISO": "50", "dilution": "stock", "developingTime": 405, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "50", "dilution": "1+1", "developingTime": 540, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "stock", "developingTime": 480, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "100", "dilution": "1+1", "developingTime": 630, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "stock", "developingTime": 570, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 720, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "stock", "developingTime": 690, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+1", "developingTime": 840, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "800", "dilution": "stock", "developingTime": 870, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "800", "dilution": "1+1", "developingTime": 1005, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ],
        "ILFORD DELTA 400 Professional": [
            "Kodak XTOL": [
                ["ISO": "200", "dilution": "stock", "developingTime": 360, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "200", "dilution": "1+1", "developingTime": 540, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "stock", "developingTime": 420, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "400", "dilution": "1+1", "developingTime": 630, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "800", "dilution": "stock", "developingTime": 480, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "800", "dilution": "1+1", "developingTime": 735, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "1600", "dilution": "stock", "developingTime": 600, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "1600", "dilution": "1+1", "developingTime": 870, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "3200", "dilution": "stock", "developingTime": 720, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5],
                ["ISO": "3200", "dilution": "1+1", "developingTime": 1020, "firstAgitationDuration": 30, "periodAgitationDuration": 30, "agitationPeriod": 5]
            ]
        ]
    ]
    
    
    func loadFilmsDataBase() {
        let filmsURL = Realm.Configuration().fileURL!.deletingLastPathComponent().appendingPathComponent("Films.realm")
        let configFilms = Realm.Configuration(fileURL: filmsURL)
        let realmForFilms = try! Realm(configuration: configFilms)
        
        var filmsToDB = List<Film>()
        for film in films.keys {
            var developers = List<Developers>()
            guard let currentFilm = films[film] else {
                return
            }
            
            for developer in currentFilm.keys {
                var devProperties = List<DevProperties>()
                guard let devProperty = currentFilm[developer] else {
                    return
                }
                
                for item in devProperty {
                    guard let property = DevProperties.parseToDB(json: item) else {
                        continue
                    }
                    
                    devProperties.append(property)
                }
                developers.append(Developers(devName: developer, devPreferences: devProperties))
            }
            filmsToDB.append(Film(filmName: film, developers: developers))
        }
        
        for item in filmsToDB {
            try! realmForFilms.write {
                realmForFilms.add(item)
            }
        }
    }
}
