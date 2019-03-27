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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userEmail.delegate = self
        userPassword.delegate = self
        
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        enableControllers(false)
        
        guard let userEmail = userEmail.text, !userEmail.isEmpty else {
            activityIndicator.stopAnimating()
            enableControllers(true)
            showInfo(title: "Field required", message: "Please fill in your email")
            return
        }
        
        guard let userPassword = userPassword.text, !userPassword.isEmpty else {
            activityIndicator.stopAnimating()
            enableControllers(true)
            showInfo(title: "Field required", message: "Please fill in your password")
            return
        }
        
        authUser(userEmail: userEmail, userPassword: userPassword)
    }
    
    private func authUser(userEmail: String, userPassword: String) {
        ClientApi.shared().login(userEmail: userEmail, userPassword: userPassword, completion: { (success, error) in
            if success {
                self.performUIUpdateOnMain {
                    self.userEmail.text = ""
                    self.userPassword.text = ""
                    self.performSegue(withIdentifier: "showMap", sender: nil)
                }
            } else {
                self.performUIUpdateOnMain {
                    self.showInfo(title: "Login failed", message: error ?? "Error while performing login")
                }
            }
            self.performUIUpdateOnMain {
                self.activityIndicator.stopAnimating()
            }
            self.enableControllers(true)
        })
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        openWithSafari("https://auth.udacity.com/sign-up")
    }
    
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: userEmail, userPassword, loginButton, signUpButton, enable: enable)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   

}
