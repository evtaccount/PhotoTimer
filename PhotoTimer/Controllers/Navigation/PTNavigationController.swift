//
//  PTNavigationController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 30/06/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class PTNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushDestinationController(id: String, class: UIViewController) {
        
    }

    func popToDataBaseViewController(animated: Bool) {
        self.viewControllers.forEach { (vc) in
            if vc.isKind(of: DataBaseViewController.self) {
                self.popToViewController(vc, animated: animated)
                return
            }
        }
        super.popToRootViewController(animated: animated)
    }
}
