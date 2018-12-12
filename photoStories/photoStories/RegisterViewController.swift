//
//  RegisterViewController.swift
//  photoStories
//
//  Created by Sasho Hadzhiev on 2/21/17.
//  Copyright © 2017 Sasho Hadzhiev. All rights reserved.
//

import UIKit
import Leanplum

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var dataDictionary:[String:Any?] = [String:Any?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        Leanplum.advance(to: "RegisterScreenState", withParameters: ["RegisterStateParamOne":"RegisteredOne"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Leanplum.advance(to: nil)
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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        self.dataDictionary[UserDefaultKeys.username.rawValue] = username
        self.dataDictionary[UserDefaultKeys.password.rawValue] = password
        DBCommunication.instance.registerUser(info: self.dataDictionary)
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.autoLoginEnabled.rawValue)
        UserDefaults.standard.set(username, forKey: UserDefaultKeys.username.rawValue)
        UserDefaults.standard.set(password, forKey: UserDefaultKeys.password.rawValue)
        Leanplum.track("Register")
        self.modalTransitionStyle = .crossDissolve
        self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
    }
}
