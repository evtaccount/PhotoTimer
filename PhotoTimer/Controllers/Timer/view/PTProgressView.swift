//
//  PTProgressView.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 28/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class PTProgressView: UIView {

    let backColor = UIColor(r: 199, g: 199, b: 204, a: 1)
    let progressColor = UIColor(r: 0, g: 122, b: 255, a: 1)
    lazy var progressView = UIView(frame: self.frame)
    
    var step: Double = 0.0
    
    var maxValue: Double = 10 {
        didSet {
            initProgressBar()
            currentValue = maxValue
            step = 1/maxValue
        }
    }
    
    var currentValue: Double = 0.0 {
        didSet {
            linearBarAnimation()
        }
    }
    
    let shapeLayer = CAShapeLayer()
    
    lazy var path = {
        UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height),
            cornerRadius: 0)
    }
    
    func initProgressBar() {
//        backgroundColor = backColor
        
        addSubview(self.progressView)
        progressView.backgroundColor = self.progressColor
        self.sendSubview(toBack: progressView)
    }
    
    func linearBarAnimation() {
        let progress = currentValue * step
        let newWidth = Double(frame.width) * (progress > 1 ? 1 : progress)
        UIView.animate(withDuration: 0.1) {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: Double(self.frame.height))
        };
    }
    
//    func set(progress: Float) {
//        let newWidth = Float(frame.width) * progress * step
//        UIView.animate(withDuration: 0.1) {
//            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: Double(self.frame.height))
//            print("width: \(newWidth), progress: \(progress), step: \(self.step)")
//        };
//    }
}
