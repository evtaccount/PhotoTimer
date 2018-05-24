

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
    var segmentStep: Float = 0.0
    let startAnglesForCurrentTimers = ["devTime": -87, "stopTime": -15, "fixTime": 57, "washTime": 129, "dryTime": 201]
    
    var currentSegmentIsActive = "" {
        didSet {
//            currentTimerShapeLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160), currentProgressBar: currentSegmentIsActive)
        }
    }
    
    @IBInspectable var maxBarValue: Float = 10 {
        didSet {
            initProgressBar()
            currentValue = maxBarValue
            step = 0.8/maxBarValue
        }
    }
    
    var maxSegmentValue: Float = 0.0 {
        didSet {
            
//            currentSegmentValue = maxSegmentValue
            segmentStep = 1/maxSegmentValue
        }
    }
    
    @IBInspectable var barWidth: Float = 10
    
    
    var currentValue: Float = 0.0 {
        didSet {
            mainProgressBarAnimation()
        }
    }
    
    var currentSegmentValue: Float = 0.0 {
        didSet {
            currentProgressBarAnimation()
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
    let mainTimerShapeLayer = CAShapeLayer()
    
    //Create track layer
    let mainTimerTrackLayer = CAShapeLayer()
    
    
    
    var currentTimerShapeLayer = CAShapeLayer()
    
    //Create gradient layer. It is background of shapeLayer
    let gradient = CAGradientLayer()
    
    
    private func initProgressBar() {
        
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width + CGFloat(barWidth),
            height: self.frame.height + CGFloat(barWidth))
        
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        
        let mainTimerCircularPath = UIBezierPath(
            arcCenter: center,
            radius: x - 20 - CGFloat(barWidth),
            startAngle: -CGFloat.pi/2,
            endAngle: CGFloat(2)*CGFloat.pi,
            clockwise: true)
        
        mainTimerTrackLayer.frame = self.bounds
        mainTimerTrackLayer.path = mainTimerCircularPath.cgPath
        mainTimerTrackLayer.strokeColor = UIColor.lightGray.cgColor
        mainTimerTrackLayer.lineWidth = CGFloat(barWidth+2)
        mainTimerTrackLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(mainTimerTrackLayer)

        mainTimerShapeLayer.path = mainTimerCircularPath.cgPath
        mainTimerShapeLayer.strokeColor = UIColor.red.cgColor
        mainTimerShapeLayer.lineWidth = CGFloat(barWidth-2)
        mainTimerShapeLayer.fillColor = UIColor.clear.cgColor
        mainTimerShapeLayer.lineCap = kCALineCapRound
        mainTimerShapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(gradient)
        self.layer.addSublayer(mainTimerShapeLayer)
        gradient.mask = mainTimerShapeLayer
        
//        currentTimerTrackLayerInit(center: CGPoint(x: 160, y: 160), x: CGFloat(160))
    }
    
    public func currentTimerTrackLayerInit(center: CGPoint, x: CGFloat) {
//        let barColors = [UIColor.green, UIColor.blue, UIColor.red, UIColor.yellow, UIColor.cyan]
        
        for ind in 0...4 {
            //Create shape layer
            let currentTimerTrackLayer = CAShapeLayer()
            
            let startAngle = -87 + 72 * ind
            let endAngle = startAngle + 66
            
            let circularPath = UIBezierPath(
                arcCenter: center,
                radius: x - CGFloat(barWidth),
                startAngle: degreesToRadians(degree: startAngle),
                endAngle: degreesToRadians(degree: endAngle),
                clockwise: true)
            
            currentTimerTrackLayer.frame = self.bounds
            currentTimerTrackLayer.path = circularPath.cgPath
            currentTimerTrackLayer.strokeColor = UIColor.lightGray.cgColor
            currentTimerTrackLayer.lineWidth = CGFloat(barWidth+2)
            currentTimerTrackLayer.lineCap = kCALineCapRound
            currentTimerTrackLayer.fillColor = UIColor.clear.cgColor
            
            self.layer.addSublayer(currentTimerTrackLayer)
        }
        
    }
    
    func currentTimerShapeLayerInit(center: CGPoint, x: CGFloat, currentProgressBar: String) {
        guard let startAngle = startAnglesForCurrentTimers[currentProgressBar] else {
            return
        }
        let endAngle = startAngle + 66
        let currentTimerCircularPath = UIBezierPath(
            arcCenter: center,
            radius: x - CGFloat(barWidth),
            startAngle: degreesToRadians(degree: startAngle),
            endAngle: degreesToRadians(degree: endAngle),
            clockwise: true)
        
        switch currentSegmentIsActive {
        case "devTime":
            let devShapeActive = CAShapeLayer()
            currentTimerShapeLayer = devShapeActive
        case "stopTime":
            let stopShapeActive = CAShapeLayer()
            currentTimerShapeLayer = stopShapeActive
        case "fixTime":
            let fixShapeActive = CAShapeLayer()
            currentTimerShapeLayer = fixShapeActive
        case "washTime":
            let washShapeActive = CAShapeLayer()
            currentTimerShapeLayer = washShapeActive
        case "dryTime":
            let dryShapeActive = CAShapeLayer()
            currentTimerShapeLayer = dryShapeActive
        default:
           break
        }
        
        currentTimerShapeLayer.path = currentTimerCircularPath.cgPath
        currentTimerShapeLayer.strokeColor = UIColor.red.cgColor
        currentTimerShapeLayer.lineWidth = CGFloat(barWidth-2)
        currentTimerShapeLayer.fillColor = UIColor.clear.cgColor
        currentTimerShapeLayer.lineCap = kCALineCapRound
        currentTimerShapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(currentTimerShapeLayer)
    }
    
    func currentProgressBarAnimation() {
        let segmentAnimation = CABasicAnimation(keyPath: "strokeEnd")

        let endSegment = (maxSegmentValue - currentSegmentValue) * segmentStep
        
        segmentAnimation.toValue = CGFloat(endSegment)
        currentTimerShapeLayer.strokeEnd = CGFloat(endSegment)

        segmentAnimation.duration = 2

        segmentAnimation.fillMode = kCAFillModeForwards
        segmentAnimation.isRemovedOnCompletion = false

        currentTimerShapeLayer.add(segmentAnimation, forKey: "urSoSegment")
    }
    
    func mainProgressBarAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        let end = (maxBarValue - currentValue) * step
        
        basicAnimation.toValue = CGFloat(end)
        mainTimerShapeLayer.strokeEnd = CGFloat(end)

        basicAnimation.duration = 1
        
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        mainTimerShapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    
    
    
    func degreesToRadians(degree: Int) -> CGFloat {
        let degreeFloat = Float(degree)
        let radian = CGFloat.pi * CGFloat(degreeFloat/180)
        return radian
    }
}
