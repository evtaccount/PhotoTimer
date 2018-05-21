//
//  EditNameViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 15/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit
import os.log

class EditNameViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    let cellIdentifier = "editNameCell"
    
    var recievedNameValue: ItemList?
    var newNameValue: ItemList?
    var textFieldValue: String?
    var saveButtonIsEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func textFieldDidEdited(_ sender: UITextField) {
//        textField.resignFirstResponder()
    }
    
    
    // MARK: - Navigation

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let index = IndexPath(row: 0, section: 0)
        let cell = self.myTableView.cellForRow(at: index) as! EditNameTableViewCell
        textFieldValue = cell.nameTextField.text
        
        newNameValue = recievedNameValue
        newNameValue?.itemValue = textFieldValue
    }
    
    func setup() {
        
    }
    
    func updateSaveButtonState() {
        let index = IndexPath(row: 0, section: 0)
        let cell = self.myTableView.cellForRow(at: index) as! EditNameTableViewCell
        guard let text = cell.nameTextField.text else {
            return
        }
        saveButton.isEnabled = !text.isEmpty
    }
}

extension EditNameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditNameTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        if let recievedNameValue = recievedNameValue {
            cell.nameTextField.text = recievedNameValue.itemValue
        } else {
            cell.nameTextField.text = ""
        }
        
        return cell
    }
}
