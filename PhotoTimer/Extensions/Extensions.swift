//
//  Extensions.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 26/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

extension Int {
    func secondsToMinutesSeconds () -> String {
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}

extension UIButton {
    func resetStyle() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func startStyle() {
        self.layer.cornerRadius = 10
    }
}

extension UIView {
//    func setCellStyle() -> UIView {
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 5.0
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = 10
//        return self
//    }
    
    func setShadowStyle() -> UIView {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.4
        
        return self
    }
}

