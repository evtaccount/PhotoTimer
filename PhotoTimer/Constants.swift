//
//  Constants.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 01/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

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
    static let timerNamesCycle = ["devTime":"stopTime", "stopTime":"fixTime", "fixTime":"washTime", "washTime":"dryTime", "dryTime":"devTime"]
}
