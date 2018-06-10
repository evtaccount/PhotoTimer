//
//  RealmDevelop.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 21/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import RealmSwift

struct TimersList {
    var timerName: String
    var timerValue: Int?
    
    init(timerName: String, timerValue: Int?) {
        self.timerName = timerName
        self.timerValue = timerValue
    }
}

struct ItemList {
    var itemName: String
    var imageName: String
    var itemValue: String?
    
    init(itemName: String, imageName: String, itemValue: String?) {
        self.itemName = itemName
        self.imageName = imageName
        self.itemValue = itemValue
    }
}

class RealmDevelop: Object {
    
    //MARK: Properties
    //Names
    @objc dynamic var schemeName: String?
    @objc dynamic var filmName: String?
    @objc dynamic var developerName: String?
    
    //Timers
    @objc dynamic var devTime: Int = 0
    @objc dynamic var stopTime: Int = 0
    @objc dynamic var fixTime: Int = 0
    @objc dynamic var washTime: Int = 0
    @objc dynamic var dryTime: Int = 0
    
    //Agitation timers
    @objc dynamic var firstAgitationDuration: Int = 0
    @objc dynamic var agitationPeriod: Int = 0
    @objc dynamic var periodAgitationDuration: Int = 0
    
    convenience init(schemeName: String?, filmName: String?, developerName: String?) {
        self.init()
        
        self.schemeName = schemeName
        self.filmName = filmName
        self.developerName = developerName
    }
    
    convenience init(filmName: String, developerName: String, devTime: Int, firstAgitationDuration: Int, agitationPeriod: Int, periodAgitationDuration: Int) {
        self.init()
        
        self.filmName = filmName
        self.developerName = developerName
        
        self.devTime = devTime
        self.stopTime = 60
        self.fixTime = 300
        self.washTime = 600
        self.dryTime = 1200
        
        self.firstAgitationDuration = firstAgitationDuration
        self.agitationPeriod = agitationPeriod
        self.periodAgitationDuration = periodAgitationDuration
    }
    
    convenience init(schemeName: String, filmName: String, developerName: String, devTime: Int, stopTime: Int, fixTime: Int, washTime: Int, dryTime: Int, firstAgitationDuration: Int, periodAgitationDuration: Int, agitationPeriod: Int) {
        self.init()
        
        self.schemeName = schemeName
        self.filmName = filmName
        self.developerName = developerName
        
        self.devTime = devTime
        self.stopTime = stopTime
        self.fixTime = fixTime
        self.washTime = washTime
        self.dryTime = dryTime
        
        self.firstAgitationDuration = firstAgitationDuration
        self.periodAgitationDuration = periodAgitationDuration
        self.agitationPeriod = agitationPeriod
    }
    
    convenience init(schemeName: String, filmName: String, developerName: String, devTime: Int, firstAgitationDuration: Int, periodAgitationDuration: Int, agitationPeriod: Int) {
        self.init()
        
        self.schemeName = schemeName
        self.filmName = filmName
        self.developerName = developerName
        
        self.devTime = devTime
        self.stopTime = 60
        self.fixTime = 300
        self.washTime = 600
        self.dryTime = 1200
        
        self.firstAgitationDuration = firstAgitationDuration
        self.periodAgitationDuration = periodAgitationDuration
        self.agitationPeriod = agitationPeriod
    }
    
    static func parse(json: Dictionary<String, Any>) -> RealmDevelop? {
        guard let schemeName = json["schemeName"] as? String,
              let filmName = json["filmName"] as? String,
              let developerName = json["developerName"] as? String,
              let devTime = json["devTime"] as? Int,
              let stopTime = json["stopTime"] as? Int,
              let fixTime = json["fixTime"] as? Int,
              let washTime = json["washTime"] as? Int,
              let dryTime = json["dryTime"] as? Int,
              let firstAgitationDuration = json["firstAgitationDuration"] as? Int,
              let periodAgitationDuration = json["periodAgitationDuration"] as? Int,
              let agitationPeriod = json["agitationPeriod"] as? Int else {
            return nil
        }
        
        return RealmDevelop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
    
}
