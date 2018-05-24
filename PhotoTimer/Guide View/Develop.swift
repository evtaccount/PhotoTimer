//
//  Develop.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 23/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class Develop {
    
    //MARK: Properties
    //Names
    var schemeName: String?
    var filmName: String?
    var developerName: String?
    
    //Timers
    var devTime: Int = 0
    var stopTime: Int = 0
    var fixTime: Int = 0
    var washTime: Int = 0
    var dryTime: Int = 0
    
    //Agitation timers
    var firstAgitationDuration: Int = 0
    var agitationPeriod: Int = 0
    var periodAgitationDuration: Int = 0
    
    init(schemeName: String?, filmName: String?, developerName: String?) {
        
        self.schemeName = schemeName
        self.filmName = filmName
        self.developerName = developerName
    }
    
    init(schemeName: String, filmName: String, developerName: String, devTime: Int, stopTime: Int, fixTime: Int, washTime: Int, dryTime: Int, firstAgitationDuration: Int, periodAgitationDuration: Int, agitationPeriod: Int) {
        
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
    
    static func parse(json: Dictionary<String, Any>) -> Develop? {
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
        
        return Develop(schemeName: schemeName, filmName: filmName, developerName: developerName, devTime: devTime, stopTime: stopTime, fixTime: fixTime, washTime: washTime, dryTime: dryTime, firstAgitationDuration: firstAgitationDuration, periodAgitationDuration: periodAgitationDuration, agitationPeriod: agitationPeriod)
    }
}
