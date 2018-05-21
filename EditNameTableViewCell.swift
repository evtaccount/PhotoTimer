//
//  EditNameTableViewCell.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 15/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class EditNameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }


}
