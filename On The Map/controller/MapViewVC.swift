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

class MapViewVC: BaseMapViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        for info in studentsInformation {
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
            ClientApi.shared().userName = studentInfo?.name ?? ""
        })
    }

}
