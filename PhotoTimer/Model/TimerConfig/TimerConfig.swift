//
//  TimerConfig.swift
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

class TimerConfig: Object {

    // MARK: - Properties
    @objc dynamic var id: String = ""

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

    // MARK: - Initialization
    convenience init(schemeName: String?, filmName: String?, developerName: String?) {
        self.init()

        self.id = NSUUID().uuidString
        self.schemeName = schemeName
        self.filmName = filmName
        self.developerName = developerName
    }

    convenience init(filmName: String,
                     developerName: String,
                     devTime: Int,
                     firstAgitationDuration: Int,
                     agitationPeriod: Int,
                     periodAgitationDuration: Int) {
        self.init()

        self.id = NSUUID().uuidString
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

    convenience init(schemeName: String,
                     filmName: String,
                     developerName: String,
                     devTime: Int,
                     stopTime: Int,
                     fixTime: Int,
                     washTime: Int,
                     dryTime: Int,
                     firstAgitationDuration: Int,
                     periodAgitationDuration: Int,
                     agitationPeriod: Int) {
        self.init()

        self.id = NSUUID().uuidString
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

    convenience init(schemeName: String,
                     filmName: String,
                     developerName: String,
                     devTime: Int,
                     firstAgitationDuration: Int,
                     periodAgitationDuration: Int,
                     agitationPeriod: Int) {
        self.init()

        self.id = NSUUID().uuidString
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

    override static func primaryKey() -> String? {
        return "id"
    }

}
