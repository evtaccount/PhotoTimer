//
//  Constants.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 01/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

struct CellNames {
    static let dbConfigCell = "dataBaseCell"
    static let dbConstructCell = "constructorCell"
    static let constructFilmCell = "constructFilmCell"
    static let constructDevCell = "constructDevCell"
    static let constructISOCell = "constructISOCell"
    static let configTextField = "configTextField"
    static let configSetTimer = "configSetTimer"
}

struct ViewControllers {
    static var dataBaseVC = "dataBaseVC"
    static var timerVC = "timerItself"
    static var constructorVC = "constructorVC"
    static var coonfiguratorVC = "configuratorVC"
    static var setTimerVC = "setTimerViewController"
}

struct CircularPB {
    static let startAnglesForCurrentTimers = ["devTime": -90, "stopTime": -18, "fixTime": 54, "washTime": 126, "dryTime": 198]
}

struct TimerConst {
    static let timerNamesCycle = ["devTime": "stopTime", "stopTime": "fixTime", "fixTime": "washTime", "washTime": "dryTime", "dryTime": "devTime"]
}

struct DataBaseCellDimentions {
    static let height = 65
    static let cornerRadius = 10.0
    static let shadowRadius = 7.0
    static let shadowOpacity = 0.4
    static let horizontalIndent = 19
    static let verticalIndent = 10
}

struct TimerColors {
    static let trackLayerColors = [
        UIColor().rgbToCGFloat(red: 95, green: 224, blue: 167, alpha: 0.3),
        UIColor().rgbToCGFloat(red: 225, green: 161, blue: 89, alpha: 0.3),
        UIColor().rgbToCGFloat(red: 211, green: 110, blue: 248, alpha: 0.3),
        UIColor().rgbToCGFloat(red: 225, green: 223, blue: 80, alpha: 0.3),
        UIColor().rgbToCGFloat(red: 254, green: 98, blue: 125, alpha: 0.3)
    ]
    
    static let shapeLayerColors = [
        "devTime": UIColor().rgbToCGFloat(red: 95, green: 224, blue: 167, alpha: 1),
        "stopTime": UIColor().rgbToCGFloat(red: 225, green: 161, blue: 89, alpha: 1),
        "fixTime": UIColor().rgbToCGFloat(red: 211, green: 110, blue: 248, alpha: 1),
        "washTime": UIColor().rgbToCGFloat(red: 225, green: 223, blue: 80, alpha: 1),
        "dryTime": UIColor().rgbToCGFloat(red: 254, green: 98, blue: 125, alpha: 1)
    ]
}

