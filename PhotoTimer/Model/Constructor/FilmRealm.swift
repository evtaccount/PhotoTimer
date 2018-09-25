//
//  Film.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 17/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation
import RealmSwift

class FilmRealm: Object {
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
