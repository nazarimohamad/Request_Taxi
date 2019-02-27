//
//  RegisterViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/27/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
    }
    

    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("there is a problem to register \(error)")
            } else {
                SVProgressHUD.dismiss()
                print("successfuly register")
                self.performSegue(withIdentifier: "home", sender: self)
            }
        }
    }
    
    
}
