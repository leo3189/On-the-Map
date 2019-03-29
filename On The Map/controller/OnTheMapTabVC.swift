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

        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsInformation), name: .reload, object: nil)
        loadStudentsInformation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        ClientApi.shared().logout(completion: { (success, error) in
            if success {
                self.performUIUpdateOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.performUIUpdateOnMain {
                    self.showInfo(title: "Error", message: error!.localizedDescription)
                }
            }
        })
    }
    
    @IBAction func addPinBtnTapped(_ sender: Any) {
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
    }
    
    @objc private func loadStudentsInformation() {
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        ClientApi.shared().studentsInformation(completion: { (studentsInformation, error) in
            if let error = error {
                
            }
        })
    }
    
    private func showPostingView(studentLocationID: String? = nil) {
        let postingVIew = storyboard?.instantiateViewController(withIdentifier: "PostingView") as! PostingView
        
    }
}
