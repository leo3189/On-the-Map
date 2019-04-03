//
//  OnTheMapTabVC.swift
//  On The Map
//
//  Created by leonard on 3/27/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OnTheMapTabVC: UITabBarController, MKMapViewDelegate {
    
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
        enableControllers(false)
        ClientApi.shared().studentInformation(completion: { (studentInformation, error) in
            if let error = error {
                self.performUIUpdateOnMain {
                    self.showInfo(title: "Error fetching student location", message: error.localizedDescription)
                }
            } else if let studentInformation = studentInformation {
                let msg = "User \"\(studentInformation.labelName)\" has already posted a Staudent Location. Whould you like to Overwrite it?"
                self.performUIUpdateOnMain {
                    self.showConfirmationAlert(message: msg, actionTitle: "Overwrite", action: {
                        self.showPostingView(studentLocationID: studentInformation.locationID)
                    })
                }
            } else {
                self.performUIUpdateOnMain {
                    self.showPostingView()
                }
            }
            self.enableControllers(true)
        })
    }
    
    @IBAction func refreshBtnTapped(_ sender: Any) {
        loadStudentsInformation()
    }
    
    @objc private func loadStudentsInformation() {
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        ClientApi.shared().studentsInformation(completion: { (studentsInformation, error) in
            if let error = error {
                self.showInfo(title: "Error", message: error.localizedDescription)
                NotificationCenter.default.post(name: .reloadCompleted, object: nil)
                return
            }
            if let studentsInformation = studentsInformation {
                StudentsLocation.shared.studentsInformation = studentsInformation
            }
            NotificationCenter.default.post(name:.reloadCompleted, object: nil)
        })
    }
    
    private func showPostingView(studentLocationID: String? = nil) {
        let postingVIew = storyboard?.instantiateViewController(withIdentifier: "PostingView") as! PostingView
        postingVIew.locationID = studentLocationID
        navigationController?.pushViewController(postingVIew, animated: true)
    }
    
    private func enableControllers(_ enable: Bool) {
        performUIUpdateOnMain {
            self.addPinButton.isEnabled = enable
            self.logOutButton.isEnabled = enable
            self.refreshButton.isEnabled = enable
        }
    }
}
