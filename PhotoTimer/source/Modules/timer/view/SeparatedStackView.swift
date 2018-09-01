//
//  SeparatedStackView.swift
//  DevelopingTimer
//
//  Created by Evgeny Evtushenko on 12/08/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class SeparatedStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if self.axis == .horizontal {
            createVerticalSeparator()
        } else {
            createHorizontalSeparator()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.axis == .horizontal {
            createVerticalSeparator()
        } else {
            createHorizontalSeparator()
        }
    }
    
    func createVerticalSeparator() {
        self.arrangedSubviews.enumerated().forEach { (idx, _) in
            if idx == 2 {//переделать
                return
            }
            let separator = UIView()
            separator.backgroundColor = .black
            self.insertArrangedSubview(separator, at: (2 * idx + 1))
            separator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
            separator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        }
    }
    
    func createHorizontalSeparator() {
        self.arrangedSubviews.enumerated().forEach { (idx, _) in
            let separator = UIView()
            separator.backgroundColor = .black
            self.insertArrangedSubview(separator, at: (2 * idx + 1))
            separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        }
        
        let separator = UIView()
        separator.backgroundColor = .black
        self.insertArrangedSubview(separator, at: 0)
        separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
