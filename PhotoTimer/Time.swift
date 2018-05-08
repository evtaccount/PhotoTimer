//
//  Timer.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 07/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class Time {
    
    //MARK: Properties
    
    var devTime: Int
    var stopTime: Int
    var fixTime: Int
    var washTime: Int
    var dryTime: Int
    
    init(devTime: Int, stopTime: Int, fixTime: Int, washTime: Int, dryTime: Int) {
        
        self.devTime = devTime
        self.stopTime = stopTime
        self.fixTime = fixTime
        self.washTime = washTime
        self.dryTime = dryTime
    }
    
}
