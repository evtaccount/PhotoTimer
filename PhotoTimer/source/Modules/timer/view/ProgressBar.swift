//
//  PTProgressBar.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 23/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

@IBDesignable class ProgressBar: UIView {
    
    @IBInspectable var startGradientColor = UIColor.red.cgColor
    @IBInspectable var endGradientColor = UIColor.blue.cgColor
    
    //Mark: Properties
    private struct Constants {
        static let lineWidth: CGFloat = 18.0
        static let startAngle: CGFloat = -.pi / 2
        static let endAngle: CGFloat = 3 * .pi / 2
    }
    
    //Coefficien for width of circular progress-bar relatively width of screen
    //    var k: CGFloat = UIScreen.main.bounds.width/375.0 {
    //        didSet {
    ////            self.frame.size = CGSize(width: 285 * k, height: 285 * k)
    //        }
    //    }
    
    var radiusCircle: CGFloat {
        return (bounds.width) / 2 - Constants.lineWidth / 2
    }
    
    var centerView: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    var step: Float = 0.0
    
    var maxBarValue: Float = 10 {
        didSet {
            initProgressBar()
            currentValue = maxBarValue
            step = 1/maxBarValue
        }
    }
    
    var currentValue: Float = 0.0 {
        didSet {
            progressBarAnimation()
        }
    }
    
    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    lazy var circularPath = {
        UIBezierPath(
            arcCenter: self.centerView,
            radius: self.radiusCircle,
            startAngle: Constants.startAngle,
            endAngle: Constants.endAngle,
            clockwise: true)
    }
    
    override func draw(_ rect: CGRect) {
        initTrackLayer()
    }
    
    func initTrackLayer() {
        trackLayer.frame = self.bounds
        trackLayer.path = circularPath().cgPath
        trackLayer.strokeColor = BaseColors.trackLayerColor.cgColor
        trackLayer.lineWidth = Constants.lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(trackLayer)
    }

    func initShapeLayer() {
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: 260,
            height: 260)
        
        gradient.colors = [startGradientColor, endGradientColor]
        
        shapeLayer.path = circularPath().cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = Constants.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        
        self.layer.addSublayer(gradient)
        self.layer.addSublayer(shapeLayer)
        gradient.mask = shapeLayer
    }
    
    //MARK: Private methods
    private func initProgressBar() {
        initTrackLayer()
        initShapeLayer()
    }
    
    //Animate main progress-bar
    private func progressBarAnimation() {
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
