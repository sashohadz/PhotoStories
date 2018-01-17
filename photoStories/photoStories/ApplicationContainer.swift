//
//  ViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum
import UserNotifications

class ApplicationContainer: UIViewController {

    var userLoggedIn:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let autoUserLoginEnabled = UserDefaults.standard.object(forKey: UserDefaultKeys.autoLoginEnabled.rawValue) {
            self.userLoggedIn = autoUserLoginEnabled as? Bool
        }
        else {
            self.userLoggedIn = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userLoggedIn == true {
            let initialVc = storyboard?.instantiateViewController(withIdentifier: "mainNavController")
            UIApplication.shared.keyWindow?.rootViewController = initialVc
            self.performSegue(withIdentifier: "ToMainScreenSegue", sender: nil)
        }
        else {
            let initialVc = storyboard?.instantiateViewController(withIdentifier: "loginNavController")
            UIApplication.shared.keyWindow?.rootViewController = initialVc
            self.performSegue(withIdentifier: "ToLoginScreenSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

