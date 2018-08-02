//
//  GuideViewController.swift
//  PhotoTimer
//
//  Created by Evgeny Evtushenko on 10/05/2018.
//  Copyright © 2018 EVT. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet var galleryView: GuideView!

    override func viewDidLoad() {
        super.viewDidLoad()

        galleryView.loadPages()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
