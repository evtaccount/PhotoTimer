//
//  Develop.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 14/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

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
        
//        self.devTime = devTime
//        self.stopTime = stopTime
//        self.fixTime = fixTime
//        self.washTime = washTime
//        self.dryTime = dryTime
        
//        self.firstAgitationDuration = firstAgitationDuration
//        self.periodAgitationDuration = periodAgitationDuration
//        self.agitationPeriod = agitationPeriod
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
}
