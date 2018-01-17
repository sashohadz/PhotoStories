//
//  LoginViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButon: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var skipRegistrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        Leanplum.onVariablesChanged {
            self.logoImageView.image = appDelegate.profileImage?.imageValue()
            NSLog((appDelegate.welcomeMessage?.stringValue())!)
        }

//        Leanplum.advance(to: "LoginScreenState", withParameters: ["LoginStateParamOne":"one"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        Leanplum.advance(to: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
//        let formatter = ISO8601DateFormatter()
//        let pdt = TimeZone(abbreviation: "PDT")
//        formatter.timeZone = pdt
//        let LoginDateString = formatter.string(from: Date())
//        print("Track Login with date: \(LoginDateString)")
//        Leanplum.setUserAttributes(["percentTest":90])
        
        guard usernameTextField.text!.characters.count > 0 else {
            let alert = UIAlertController.init(title: "Error", message: "Please enter a username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let passwordString = String(self.passwordTextField.text!)
        
        DBCommunication.instance.login(with: self.usernameTextField.text!, password: passwordString!) { (success) in
            if success == true {
                UserDefaults.standard.set(self.usernameTextField.text, forKey: UserDefaultKeys.username.rawValue)
                UserDefaults.standard.set(self.passwordTextField.text, forKey: UserDefaultKeys.password.rawValue)
                UserDefaults.standard.set(true, forKey: UserDefaultKeys.autoLoginEnabled.rawValue)
                
                Leanplum.setUserId(self.usernameTextField.text)
                
//                Leanplum.track("Login", withParameters: ["LastLoginDate":LoginDateString])
//                Leanplum.setUserAttributes(["LastLoginDate":LoginDateString])set
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginCompletedSegue", sender: nil)
                }
            }
            else {
                let alert = UIAlertController.init(title: "Error", message: "Wrong username or passowrd", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        Leanplum.track("Go to Register")
    }
}
