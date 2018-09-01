//
//  SubtimersView.swift
//  DevelopingTimer
//
//  Created by Evgeny Evtushenko on 12/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class SubtimersView: UIView {
    
    @IBOutlet weak var developLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var fixingLabel: UILabel!
    @IBOutlet weak var washingLabel: UILabel!
    @IBOutlet weak var dryingLabel: UILabel!
    
    @IBOutlet weak var firstLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLineConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var developingStackView: PTProgressStackView!
    @IBOutlet weak var stoppingStackView: PTProgressStackView!
    @IBOutlet weak var fixingStackView: PTProgressStackView!
    @IBOutlet weak var washingStackView: PTProgressStackView!
    @IBOutlet weak var dryingStackView: PTProgressStackView!
    
    let flippedHieght: CGFloat = 28
    let unflippedHeight: CGFloat = 45
    var progressBars = [PTProgressStackView]()
    
    var maxBarValue: Double = 10 {
        didSet {
            progressBars[0].maxValue = maxBarValue
        }
    }
    
    var currentBarValue: Double = 0 {
        didSet {
            progressBars[0].currentValue = currentBarValue
        }
    }
    
    var isFlipped: Bool = true {
        didSet {
            hideShowMenu()
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressBars = [developingStackView, stoppingStackView, fixingStackView, washingStackView, dryingStackView]
    }
    
    func hideShowMenu() {
        let hideTimerValues = {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.developLabel.isHidden = true
                self.stopLabel.isHidden = true
                self.fixingLabel.isHidden = true
                
                self.washingLabel.isHidden = true
                self.dryingLabel.isHidden = true
                
                self.firstLineConstraint.constant = self.flippedHieght
                self.secondLineConstraint.constant = self.flippedHieght
                
                self.developingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.developingStackView.progressView.frame.width, height: self.flippedHieght)
                
                self.stoppingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.stoppingStackView.progressView.frame.width, height: self.flippedHieght)
                
                self.fixingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.fixingStackView.progressView.frame.width, height: self.flippedHieght)
                
                self.washingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.washingStackView.progressView.frame.width, height: self.flippedHieght)
                
                self.dryingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.dryingStackView.progressView.frame.width, height: self.flippedHieght)
                
                self.stackView.layoutIfNeeded()
            })
        }
            
            let showTimerValues = {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.developLabel.isHidden = false
                    self.stopLabel.isHidden = false
                    self.fixingLabel.isHidden = false
                    
                    self.washingLabel.isHidden = false
                    self.dryingLabel.isHidden = false
                    
                    self.firstLineConstraint.constant = self.unflippedHeight
                    self.secondLineConstraint.constant = self.unflippedHeight
                    
                    self.developingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.developingStackView.progressView.frame.width, height: self.unflippedHeight)
                    
                    self.stoppingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.stoppingStackView.progressView.frame.width, height: self.unflippedHeight)
                    
                    self.fixingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.fixingStackView.progressView.frame.width, height: self.unflippedHeight)
                    
                    self.washingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.washingStackView.progressView.frame.width, height: self.unflippedHeight)
                    
                    self.dryingStackView.progressView.frame = CGRect(x: 0, y: 0, width: self.dryingStackView.progressView.frame.width, height: self.unflippedHeight)
                    
                    self.stackView.layoutIfNeeded()
                })
            }
        isFlipped ? hideTimerValues() : showTimerValues()
    }
    
    func configureLabels(with timer: TimerConfig) {
        developLabel.text = timer.devTime.secondsToMinutesSeconds()
        stopLabel.text = timer.stopTime.secondsToMinutesSeconds()
        fixingLabel.text = timer.fixTime.secondsToMinutesSeconds()
        washingLabel.text = timer.washTime.secondsToMinutesSeconds()
        dryingLabel.text = timer.dryTime.secondsToMinutesSeconds()
    }
}
