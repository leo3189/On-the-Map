//
//  PostingViewVC.swift
//  On The Map
//
//  Created by leonard on 3/28/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit
import CoreLocation

class PostingView: UIViewController {
    
    @IBOutlet weak var enterLocationTF: UITextField!
    @IBOutlet weak var enterWebSiteTF: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationID: String?
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterLocationBtnTapped(_ sender: Any) {
        let location = enterLocationTF.text!
        let link = enterWebSiteTF.text!
        
        if location.isEmpty || link.isEmpty {
            showInfo(message: "All fields are required")
            return
        }
        
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showInfo(message: "Please provide a valid link")
            return
        }
        
        geocode(location: location)
    }
    
    @IBAction func enterWebSiteBtnTapped(_ sender: Any) {
    }
    
    @IBAction func findLocationBtnTapped(_ sender: Any) {
    }
    
    private func geocode(location: String) {
        enableControllers(false)
        activityIndicator.startAnimating()
        
        geocoder.geocodeAddressString(location, completionHandler: { (placemarkers, error) in
            self.enableControllers(true)
            self.performUIUpdateOnMain {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.showInfo(title: "Error", message: "Unable to forward geocode address \(error)")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    self.syncStudentLocation(location.coordinate)
                } else {
                    self.showInfo(message: "No matching location found")
                }
            }
        })
    }
    
    private func syncStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        self.enableControllers(true)
        
        
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        let nameComponents = ClientApi.shared().userName.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let lastName = nameComponents.last ?? ""
        
        var studentInfo = [
            "uniqueKey": ClientApi.shared().userKey,
            "fisrtName": firstName,
            "lastName": lastName,
            "mapString": enterLocationTF.text!,
            "mediaURL": enterWebSiteTF.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude] as [String: AnyObject]
        
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
        
        return StudentInformation(studentInfo)
    }
    
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: enterLocationTF, enterWebSiteTF, findLocationButton, enable: enable)
    }
    
    private func setUpNavBar() {
        self.navigationItem.title = "Add Location"
        
        let backButton = UIBarButtonItem()
        backButton.title = "CANCEL"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
