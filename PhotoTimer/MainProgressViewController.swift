//
//  MainProgressViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 12/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class MainProgressViewController: UIViewController {

    @IBOutlet var mainProgressBar: MainProgressBar!
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainProgressBar.createScene()
    }
   
    @IBAction func actionButton(_ sender: Any) {
        
//        mainProgressBar.currentValue += 0.1
        
    }
    
}
