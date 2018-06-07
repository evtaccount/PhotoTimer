 

//
//  CircularProgressBar.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 09/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class CircularProgressBar: UIView {
    
    //Mark: Properties
    var step: Float = 0.0
    var segmentStep: Float = 0.0
    let startAnglesForCurrentTimers = ["devTime": -90, "stopTime": -18, "fixTime": 54, "washTime": 126, "dryTime": 198]
    
    //Coefficien for width of circular progress-bar relatively width of screen
    var k: CGFloat = UIScreen.main.bounds.width/375.0 {
        didSet {
//            self.frame.size = CGSize(width: 285 * k, height: 285 * k)
        }
    }
    
    //Main circular progress-bar radius
    var radiusCircle: CGFloat {
        return (self.frame.size.width) / 2 - 19
    }
    
    var radiusSegmentsCircle: CGFloat {
        return (self.frame.size.width) / 2
    }
    
    //The center of circular progress-bar
    public var centerView: CGPoint {
        return CGPoint(x: self.frame.size.width/2, y: self.frame.size.width/2)
    }
    
    //Mark of cunnert segment name. When something sets it up, this property with name of new current segment call initializer of choosen shape-layer segment
    var currentSegmentIsActive = "" {
        didSet {
            currentTimerShapeLayerInit(currentProgressBar: currentSegmentIsActive)
        }
    }
    
    //This is the maximum value of main progress-bar. When something sets up, it calls the initializer for its track and shape layers and sets start current value and step
    var maxBarValue: Float = 10 {
        didSet {
            initProgressBar()
            currentValue = maxBarValue
            step = 0.8/maxBarValue
        }
    }
    
    //This is the maximum value of current segment progress-bar. When something sets up, it calculate the step of current timer for this segment
    var maxSegmentValue: Float = 0.0 {
        didSet {
            segmentStep = 1/maxSegmentValue
        }
    }
    
    //This is the current value of main progress-bar. Calls animation for update its value
    var currentValue: Float = 0.0 {
        didSet {
            mainProgressBarAnimation()
        }
    }
    
    //The width of shape circular bars
    var barWidth: Float = 10
    
    //This is the current value of current segment progress-bar. Calls animation for update its value
    var currentSegmentValue: Float = 0.0 {
        didSet {
            currentProgressBarAnimation()
        }
    }
    
    //Main progress-bar track and shape layers
    let mainTimerTrackLayer = CAShapeLayer()
    let mainTimerShapeLayer = CAShapeLayer()
    
    //Current segment shape layer
    var currentTimerShapeLayer = CAShapeLayer()
    
    //Background of shapeLayer of main circular bar
    let gradient = CAGradientLayer()
    
    //MARK: Private methods
    //Initialize track and shape layers of main progress-bar. Main progress-bar is gradiented, so it uses the gradient mask
    private func initProgressBar() {
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: self.frame.height)
        
        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        
        let mainTimerCircularPath = UIBezierPath(
            arcCenter: centerView,
            radius: radiusCircle - CGFloat(4),
            startAngle: -CGFloat.pi/2,
            endAngle: CGFloat(2)*CGFloat.pi,
            clockwise: true)
        
        mainTimerTrackLayer.frame = self.bounds
        mainTimerTrackLayer.path = mainTimerCircularPath.cgPath
        mainTimerTrackLayer.strokeColor = UIColor.lightGray.cgColor
        mainTimerTrackLayer.lineWidth = CGFloat(4)
        mainTimerTrackLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(mainTimerTrackLayer)

        mainTimerShapeLayer.path = mainTimerCircularPath.cgPath
        mainTimerShapeLayer.strokeColor = UIColor.red.cgColor
        mainTimerShapeLayer.lineWidth = CGFloat(4)
        mainTimerShapeLayer.fillColor = UIColor.clear.cgColor
        mainTimerShapeLayer.lineCap = kCALineCapRound
        mainTimerShapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(gradient)
        self.layer.addSublayer(mainTimerShapeLayer)
        gradient.mask = mainTimerShapeLayer
    }
    
    //Resets track-layer for sub-timers and initialize shape-layer for the first segment
    func resetCircles() {
        initTrackLayerSegment()
        currentTimerShapeLayerInit(currentProgressBar: "devTime")
    }
    
    //Initialize current segment shape-layer
    private func currentTimerShapeLayerInit(currentProgressBar: String) {
        guard let startAngle = startAnglesForCurrentTimers[currentProgressBar] else {
            return
        }
        
        let shapeLayerColors = [
            "devTime": rgbToCGFloat(red: 95, green: 224, blue: 167, alpha: 1),
            "stopTime": rgbToCGFloat(red: 225, green: 161, blue: 89, alpha: 1),
            "fixTime": rgbToCGFloat(red: 211, green: 110, blue: 248, alpha: 1),
            "washTime": rgbToCGFloat(red: 225, green: 223, blue: 80, alpha: 1),
            "dryTime": rgbToCGFloat(red: 254, green: 98, blue: 125, alpha: 1)
        ]
        
        let endAngle = startAngle + 72
        let currentTimerCircularPath = UIBezierPath(
            arcCenter: centerView,
            radius: radiusSegmentsCircle - CGFloat(10),
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
        currentTimerShapeLayer.strokeColor = shapeLayerColors[currentSegmentIsActive]?.cgColor
        currentTimerShapeLayer.lineWidth = CGFloat(10)
        currentTimerShapeLayer.fillColor = UIColor.clear.cgColor
//        currentTimerShapeLayer.lineCap = kCALineCapRound
        currentTimerShapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(currentTimerShapeLayer)
    }
    
    //Animate current segment progress-bar
    private func currentProgressBarAnimation() {
        let segmentAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let endSegment = (maxSegmentValue - currentSegmentValue) * segmentStep
        
        segmentAnimation.toValue = CGFloat(endSegment)
        currentTimerShapeLayer.strokeEnd = CGFloat(endSegment)

        segmentAnimation.duration = 1
        segmentAnimation.fillMode = kCAFillModeForwards
        segmentAnimation.isRemovedOnCompletion = false

        currentTimerShapeLayer.add(segmentAnimation, forKey: "urSoSegment")
    }
    
    //Animate main progress-bar
    private func mainProgressBarAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let end = (maxBarValue - currentValue) * step
        
        basicAnimation.toValue = CGFloat(end)
        mainTimerShapeLayer.strokeEnd = CGFloat(end)

        basicAnimation.duration = 1
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        mainTimerShapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    //Convert degrees to radians for drawing circles
    private func degreesToRadians(degree: Int) -> CGFloat {
        let degreeFloat = Float(degree)
        let radian = CGFloat.pi * CGFloat(degreeFloat/180)
        return radian
    }
    
    private func rgbToCGFloat(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        let redFloat = CGFloat(Float(red)/255.0)
        let greenFloat = CGFloat(Float(green)/255.0)
        let blueFloat = CGFloat(Float(blue)/255.0)
        
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: CGFloat(alpha))
    }
    
    public func clearSegmentLayers() {
        let clearLayer = CAShapeLayer()
        let clearCircularPath = UIBezierPath(
            arcCenter: centerView,
            radius: radiusSegmentsCircle - CGFloat(10),
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true)
        clearLayer.frame = self.bounds
        clearLayer.path = clearCircularPath.cgPath
        clearLayer.strokeColor = UIColor.white.cgColor
        clearLayer.lineWidth = CGFloat(10)
        clearLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(clearLayer)
    }
    
    //MARK: Public methods
    //Initialize of all five track-layer segments for sub-timers
    public func initTrackLayerSegment() {
        let trackLayerColors = [
            rgbToCGFloat(red: 95, green: 224, blue: 167, alpha: 0.3),
            rgbToCGFloat(red: 225, green: 161, blue: 89, alpha: 0.3),
            rgbToCGFloat(red: 211, green: 110, blue: 248, alpha: 0.3),
            rgbToCGFloat(red: 225, green: 223, blue: 80, alpha: 0.3),
            rgbToCGFloat(red: 254, green: 98, blue: 125, alpha: 0.3)
        ]
        
        for ind in 0...4 {
            //Create shape layer
            let currentTimerTrackLayer = CAShapeLayer()
            
            let startAngle = -90 + 72 * ind
            let endAngle = startAngle + 72
            
            let circularPath = UIBezierPath(
                arcCenter: centerView,
                radius: radiusSegmentsCircle - CGFloat(10),
                startAngle: degreesToRadians(degree: startAngle),
                endAngle: degreesToRadians(degree: endAngle),
                clockwise: true)
            
            currentTimerTrackLayer.frame = self.bounds
            currentTimerTrackLayer.path = circularPath.cgPath
            currentTimerTrackLayer.strokeColor = trackLayerColors[ind].cgColor
            currentTimerTrackLayer.lineWidth = CGFloat(10)
//            currentTimerTrackLayer.lineCap = kCALineCapRound
            currentTimerTrackLayer.fillColor = UIColor.clear.cgColor
            
            self.layer.addSublayer(currentTimerTrackLayer)
        }
    }
}
