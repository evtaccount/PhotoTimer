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
    let devPreferences = List<DevPreferences>()
    
    convenience init(devName: String, devPreferences: List<DevPreferences>) {
        self.init()
        
        self.devName = devName
        for item in devPreferences {
            self.devPreferences.append(item)
        }
    }
}

class DevPreferences: Object {
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
}
