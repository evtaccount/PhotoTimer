//
//  ConstructorTableViewCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 08/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class DataBaseConstructorCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}
