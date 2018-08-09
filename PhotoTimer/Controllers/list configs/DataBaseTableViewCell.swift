//
//  DataBaseTableViewCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 19/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import SwipeCellKit

class DataBaseTimerCell: SwipeTableViewCell {

    @IBOutlet weak var timerNameTextLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCellStyle()
    }

    func setCellStyle() {
        self.contentView.backgroundColor = UIColor.clear

        let cellBackgroundLayer: UIView = UIView(frame: CGRect(x: DataBaseCellDimentions.horizontalIndent,
                                                                y: DataBaseCellDimentions.verticalIndent,
                                                                width: Int(UIScreen.main.bounds.width) - 2 * DataBaseCellDimentions.horizontalIndent,
                                                                height: DataBaseCellDimentions.height))
        cellBackgroundLayer.setShadowStyle()

        self.addSubview(cellBackgroundLayer)
        self.sendSubview(toBack: cellBackgroundLayer)
    }
}

class DataBaseButtonCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCellStyle()
    }

    func setCellStyle() {
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width) - 2 * DataBaseCellDimentions.horizontalIndent,
            height: DataBaseCellDimentions.height)

        let startColor = UIColor().rgbToCGFloat(red: 254, green: 181, blue: 90, alpha: 1.0)
        let endColor = UIColor().rgbToCGFloat(red: 254, green: 141, blue: 97, alpha: 1.0)
        backgroundGradient.colors = [startColor, endColor]
        backgroundGradient.cornerRadius = 10
        backgroundGradient.masksToBounds = false
        backgroundGradient.shadowOffset = CGSize(width: 0.0, height: 0.0)
        backgroundGradient.shadowRadius = 7
        backgroundGradient.shadowOpacity = 0.4

        let cellShadowLayer: UIView = UIView(frame: CGRect(x: 19, y: 10, width: UIScreen.main.bounds.width - 38, height: 65))
        cellShadowLayer.layer.addSublayer(backgroundGradient)

        self.addSubview(cellShadowLayer)
        self.sendSubview(toBack: cellShadowLayer)
    }
}
