//
//  Extensions.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 26/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

extension Int {
    func secondsToMinutesSeconds () -> String {
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

