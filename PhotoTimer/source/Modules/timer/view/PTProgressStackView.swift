//
//  PTProgressStackView.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 29/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class PTProgressStackView: UIStackView {

    lazy var progressView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.height))
    
    var step: Double = 0.0
    
    var maxValue: Double = 10 {
        didSet {
            initProgressBar()
            step = 1/maxValue
        }
    }
    
    var currentValue: Double = 0.0 {
        didSet {
            linearBarAnimation()
        }
    }
    
    func initProgressBar() {
        addSubview(self.progressView)
        progressView.backgroundColor = BaseColors.linearProgressColor
        self.sendSubview(toBack: progressView)
    }
    
    func linearBarAnimation() {
        let progress = (maxValue - currentValue) * step
        let newWidth = Double(frame.width) * (progress > 1 ? 1 : progress)
        UIView.animate(withDuration: 0.1) {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newWidth, height: Double(self.frame.height))
        };
    }

}
