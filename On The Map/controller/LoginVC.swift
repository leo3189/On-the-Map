//
//  LoginVC.swift
//  On The Map
//
//  Created by leonard on 3/21/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userEmail.delegate = self
        userPassword.delegate = self
        
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        ClientApi.login(username: userEmail.text!, password: userPassword.text!, completion: { (success, error) in
            if success {
                print(success)
            } else {
                print("LoginVC Completion: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
   

}
