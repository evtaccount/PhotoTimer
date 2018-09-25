//
//  DataBaseTimerCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 12/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import SwipeCellKit

class DataBaseTimerCell: SwipeTableViewCell {
    
    @IBOutlet weak var timerNameTextLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(with configuration: TimerConfig) {
        guard let timerName = configuration.schemeName else { return }
        
        timerNameTextLabel.text = timerName
        infoTextLabel.text = "\(configuration.devTime.secondsToMinutesSeconds()) / \(configuration.stopTime.secondsToMinutesSeconds()) / \(configuration.fixTime.secondsToMinutesSeconds()) / \(configuration.washTime.secondsToMinutesSeconds()) / \(configuration.dryTime.secondsToMinutesSeconds())"
    }
}
