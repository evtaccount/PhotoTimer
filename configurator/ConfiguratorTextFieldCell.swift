//
//  ConfiguratorTextFieldCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 25/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import Foundation

import UIKit

class ConfiguratorTextFieldCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var itemTextField: UITextField!
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
}
