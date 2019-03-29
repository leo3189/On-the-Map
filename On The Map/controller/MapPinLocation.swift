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
            let location = Loca
        }
        
    }
    
    @IBAction func finishBtnTapped(_ sender: Any) {
    }
    
   

}
