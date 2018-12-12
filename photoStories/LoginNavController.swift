//
//  LoginNavController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 6/20/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
//import LeanplumLocation

class LoginNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        if(LPLocationManager.shared().needsAuthorization) {
//            LPLocationManager.shared().authorize()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
