

//
//  CircularProgressBar.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

@IBDesignable class CircularProgressBar: UIView {
    
    //Mark: Properties
    
    var step: Float = 0.0
    
    @IBInspectable var maxBarValue: Float = 10 {
        didSet {
            initProgressBar()
            currentValue = maxBarValue
        }
    }
    
    @IBInspectable var barWidth: Float = 10
    
    
    var currentValue: Float = 0.0 {
        didSet {
            handleTap()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initProgressBar()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
//        initProgressBar()
    }
    
    //Create shape layer
    let shapeLayer = CAShapeLayer()
    
    //Create track layer
    let trackLayer = CAShapeLayer()
    
    
    
    
    func initProgressBar() {
        
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: x, startAngle: -CGFloat.pi/2, endAngle: CGFloat(2)*CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = CGFloat(barWidth+2)
        trackLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = CGFloat(barWidth-2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
        
        step = 0.8/maxBarValue
    }
    
    
    func handleTap() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        let end = (maxBarValue - currentValue) * step
        
        basicAnimation.toValue = CGFloat(end)
        shapeLayer.strokeEnd = CGFloat(end)

        
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
}
