//
//  MapViewVC.swift
//  On The Map
//
//  Created by leonard on 4/3/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Map View")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
        loadUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadStarted() {
        performUIUpdateOnMain {
            self.activityIndicator.startAnimating()
            self.mapView.alpha = 0.5
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdateOnMain {
            self.activityIndicator.stopAnimating()
            self.mapView.alpha = 1
            self.showStudentsInformation(StudentsLocation.shared.studentsInformation)
        }
    }
    
    private func showStudentsInformation(_ studentsInformation: [StudentInformation]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for info in studentsInformation where info.latitude != 0 && info.longitude != 0 {
            let annotion = MKPointAnnotation()
            annotion.title = info.labelName
            annotion.subtitle = info.mediaURL
            annotion.coordinate = CLLocationCoordinate2DMake(info.latitude, info.longitude)
            mapView.addAnnotation(annotion)
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    private func loadUserInfo() {
        _ = ClientApi.shared().studentInfo(completion: { (studentInfo, error) in
            if let error = error {
                self.showInfo(title: "Error", message: error.localizedDescription)
                return
            }
            ClientApi.shared().userName = studentInfo?.user.name ?? ""
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {
                self.showInfo(message: "No link defined")
                return
            }
            
            guard let link = subtitle else {
                self.showInfo(message: "No link defined")
                return
            }
            
            openWithSafari(link)
        }
    }


}
