//
//  PTProgressBar.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 23/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

@IBDesignable class PTProgressBar: UIView {

    @IBInspectable var startGradientColor: UIColor = UIColor.blue
    @IBInspectable var endGradientColor: UIColor = UIColor.orange
    @IBInspectable var gradientAngle: CGFloat = 0.0
    @IBInspectable var currentBarValue: Int = 30 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var maxBarValue: Int = 60 {
        didSet {
            step = 0.8 / CGFloat(maxBarValue)
        }
    }

    private struct Constants {
        static let lineWidth: CGFloat = 15.0
        static let startAngle: CGFloat = -.pi / 2
        static let endAngle: CGFloat = 3 * .pi / 2
    }

    var radius: CGFloat {
        return max(bounds.width, bounds.height) / 2
    }
    var centerView: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    var step: CGFloat = 0.0

    let trackLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let gradient = CAGradientLayer()

    lazy var circularPath = UIBezierPath(arcCenter: centerView,
                                    radius: radius - Constants.lineWidth,
                                    startAngle: Constants.startAngle,
                                    endAngle: Constants.endAngle,
                                    clockwise: true)

    override func draw(_ rect: CGRect) {
        initTrackLayer(path: circularPath)
    }

    func initProgressBar() {
        initTrackLayer(path: circularPath)
        initShapeLayer(path: circularPath)
    }

    func initTrackLayer(path: UIBezierPath) {
        trackLayer.frame = self.bounds
        trackLayer.path = path.cgPath
        trackLayer.lineWidth = Constants.lineWidth
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor

        self.layer.addSublayer(trackLayer)
    }

    func initShapeLayer(path: UIBezierPath) {
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: bounds.height)

        gradient.colors = [startGradientColor.cgColor, endGradientColor.cgColor]

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = Constants.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0

        self.layer.addSublayer(gradient)
        self.layer.addSublayer(shapeLayer)
        gradient.mask = shapeLayer
    }
}
