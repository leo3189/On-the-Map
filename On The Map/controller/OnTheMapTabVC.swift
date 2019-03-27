//
//  OnTheMapTabVC.swift
//  On The Map
//
//  Created by leonard on 3/27/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit

class OnTheMapTabVC: UITabBarController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        ClientApi.shared().logout(completion: { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showInfo(title: "Error", message: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func addPinBtnTapped(_ sender: Any) {
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
    }
}
