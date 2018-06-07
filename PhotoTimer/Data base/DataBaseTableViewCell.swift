//
//  DataBaseTableViewCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 19/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import SwipeCellKit

class DataBaseTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var timerNameTextLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set {
//            var frame = newValue
//            frame.origin.x += 19
//            frame.size.width -= 2 * 19
//
//            self.contentView.backgroundColor = UIColor.white
//            self.contentView.layer.masksToBounds = false
//            self.contentView.layer.cornerRadius = 10.0
//            self.contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//            self.contentView.layer.shadowRadius = 7
//            self.contentView.layer.shadowOpacity = 0.4
////            self.accessoryType = .disclosureIndicator
//
//            super.frame = frame
//        }
//    }

}
