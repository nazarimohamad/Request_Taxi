//
//  ViewController.swift
//  Uber
//
//  Created by Ryan Nazari on 2/1/19.
//  Copyright © 2019 Ryan Nazari. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                print(error)
            } else {
                self.performSegue(withIdentifier: "home", sender: self)
                
            }
        }
        
    }
    
    
    
    
    
}

