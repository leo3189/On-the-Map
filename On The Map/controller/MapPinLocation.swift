//
//  MapPinLocation.swift
//  On The Map
//
//  Created by leonard on 3/29/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinLocation: OnTheMapTabVC {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        if let studentLocation = studentInformation {
            let location = Location(
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            showLocations(location: location)
            
        }
        
    }
    
    @IBAction func finishBtnTapped(_ sender: Any) {
        if let studentLocation = studentInformation {
            showNetworkOperation(true)
            if studentLocation.locationID == nil {
                ClientApi.shared()
            }
        }
    }
    
    private func showLocations(location: Location) {
        mapView.removeAnnotation(mapView!.annotations as! MKAnnotation)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            self.showInfo(title: "Error", message: error.localizedDescription)
        } else {
            self.showInfo(title: "Success", message: "Student Location updated", action: {
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: .reload, object: nil)
            })
        }
    }
    
    private func showNetworkOperation(_ show: Bool) {
        performUIUpdateOnMain {
            self.finishButton.isEnabled = !show
            self.mapView.alpha = show ? 0.5 : 1
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

}
