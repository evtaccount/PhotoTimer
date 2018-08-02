//
//  SubtimersView.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 18/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class SubtimersView: UIView {

    @IBOutlet weak var developLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var fixingLabel: UILabel!
    @IBOutlet weak var washingLabel: UILabel!
    @IBOutlet weak var dryingLabel: UILabel!

    @IBOutlet weak var agitationFirstLabel: UILabel!
    @IBOutlet weak var agitationDurationLabel: UILabel!
    @IBOutlet weak var agitationPeriodLabel: UILabel!

    @IBOutlet weak var firstLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLineConstraint: NSLayoutConstraint!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fixingStackView: UIStackView!
    @IBOutlet weak var washingStackView: UIStackView!
    @IBOutlet weak var dryingStackView: UIStackView!

    @IBOutlet weak var agitationStackView: UIStackView!
    @IBOutlet weak var editStackView: UIStackView!
//    @IBOutlet weak var agitationConstraint: NSLayoutConstraint!

    var flag: Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        agitationStackView.isHidden = true
    }

    func hideMenu() {
        if flag {
            flag = false
            UIView.animate(withDuration: 0.25, animations: {
                self.developLabel.isHidden = true
                self.stopLabel.isHidden = true
                self.fixingLabel.isHidden = true

                self.washingLabel.isHidden = true
                self.dryingLabel.isHidden = true

                self.firstLineConstraint.constant = 22.5
                self.secondLineConstraint.constant = 22.5

                self.fixingStackView.layoutIfNeeded()
                self.washingStackView.layoutIfNeeded()
                self.dryingStackView.layoutIfNeeded()

                self.editStackView.isHidden = true

//                self.agitationStackView.isHidden = true
                self.stackView.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: 0.2, animations: {

                })
            }
        } else {
            flag =  true
            UIView.animate(withDuration: 0.25, animations: {
                self.developLabel.isHidden = false
                self.stopLabel.isHidden = false
                self.fixingLabel.isHidden = false

                self.washingLabel.isHidden = false
                self.dryingLabel.isHidden = false

                self.firstLineConstraint.constant = 45
                self.secondLineConstraint.constant = 45

                self.fixingStackView.layoutIfNeeded()
                self.washingStackView.layoutIfNeeded()
                self.dryingStackView.layoutIfNeeded()

                self.editStackView.isHidden = false
//                self.agitationStackView.isHidden = false
                self.stackView.layoutIfNeeded()
            }) { (_) in

            }
//            UIView.animate(withDuration: 0.25) {
//                self.anitationView.isHidden = false
//                self.agitationConstraint.constant = 45
//            }
//            self.anitationView.alpha = 1
        }

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
