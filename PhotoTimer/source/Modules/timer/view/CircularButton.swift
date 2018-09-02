//
//  CircularButton.swift
//  DevelopingTimer
//
//  Created by Evgeny Evtushenko on 11/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

@IBDesignable class CircularButton: UIButton {
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isPlayButton: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private struct Constants {
        static let playLineWidth: CGFloat = 1.0
        static let pauseLineWidth: CGFloat = 7.0
        static let iconScale: CGFloat = 0.4
        static let shiftToCenter: CGFloat = 7
    }
    
    private var centerX: CGFloat {
        return bounds.width / 2
    }
    
    private var centerY: CGFloat {
        return bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        BaseColors.circularButtonColor.setFill()
        path.fill()
        
        let playIcon = {
            let playIconSize: CGFloat = min(self.bounds.width, self.bounds.height) * Constants.iconScale
            let halfPlayIconSize = playIconSize / 2
            
            let playPath = UIBezierPath()
            
            playPath.lineWidth = Constants.playLineWidth
            
            playPath.move(to: CGPoint(
                x: self.centerX - halfPlayIconSize + Constants.shiftToCenter,
                y: self.centerY - halfPlayIconSize))
            
            playPath.addLine(to: CGPoint(
                x: self.centerX + halfPlayIconSize + Constants.shiftToCenter,
                y: self.centerY))
            
            playPath.addLine(to: CGPoint(
                x: self.centerX - halfPlayIconSize + Constants.shiftToCenter,
                y: self.centerY + halfPlayIconSize))
            
            playPath.close()
            
            UIColor.white.setFill()
            playPath.fill()
        }
        
        let pauseIcon = {
            let pauseIconHeight: CGFloat = self.bounds.height * Constants.iconScale
            let pauseIconWidth: CGFloat = pauseIconHeight * 0.6
            
            let halfPauseIconHeight = pauseIconHeight / 2
            let halfPauseIconWidth = pauseIconWidth / 2
            
            let pausePath = UIBezierPath()
            
            pausePath.lineWidth = Constants.pauseLineWidth
            
            pausePath.move(to: CGPoint(
                x: self.centerX - halfPauseIconWidth,
                y: self.centerY - halfPauseIconHeight))
            
            pausePath.addLine(to: CGPoint(
                x: self.centerX - halfPauseIconWidth,
                y: self.centerY + halfPauseIconHeight))
            
            pausePath.move(to: CGPoint(
                x: self.centerX + halfPauseIconWidth,
                y: self.centerY - halfPauseIconHeight))
            
            pausePath.addLine(to: CGPoint(
                x: self.centerX + halfPauseIconWidth,
                y: self.centerY + halfPauseIconHeight))
            
            UIColor.white.setStroke()
            pausePath.stroke()
        }
        
        isPlayButton ? playIcon() : pauseIcon()
        
    }
    
}
