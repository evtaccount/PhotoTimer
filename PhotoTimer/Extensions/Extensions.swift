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
    
    func degreesToRadians() -> CGFloat {
        let degreeFloat = Float(self)
        let radian = CGFloat.pi * CGFloat(degreeFloat/180)
        return radian
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
    func setShadowStyle() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 0.4
    }
}

extension UIColor {
    func rgbToCGFloat(red: Int, green: Int, blue: Int, alpha: Float) -> CGColor {
        let redFloat = CGFloat(Float(red)/255.0)
        let greenFloat = CGFloat(Float(green)/255.0)
        let blueFloat = CGFloat(Float(blue)/255.0)
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: CGFloat(alpha)).cgColor
    }
}

extension UITableViewCell {
    func addBackgroundLayer() {
        let cellBackgroundLayer : UIView = UIView(frame: CGRect(x: 19, y: 10, width: UIScreen.main.bounds.width - 38, height: 65))
        cellBackgroundLayer.setShadowStyle()
        
        self.addSubview(cellBackgroundLayer)
        self.sendSubview(toBack: cellBackgroundLayer)
    }
}

extension UINavigationController {
    func makeNavigationBarTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    func resetNavigationBar() {
        self.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.isTranslucent = false
    }
}
