//
//  SubTimerView.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 17/07/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class SubTimerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBorderForView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createBorderForView()
    }

    public func createBorderForView() {
        self.layer.borderWidth = CGFloat(0.5)
//        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        let cgColor: CGColor = UIColor.black.cgColor
        self.layer.borderColor = cgColor
    }
}
