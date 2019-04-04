//
//  ListVC.swift
//  On The Map
//
//  Created by leonard on 4/3/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit

class ListVC: UIViewController, LocationSelectionDelegate {
    
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        dataProvider.delegate = self
        listTV.dataSource = dataProvider
        listTV.delegate = dataProvider
        
        reloadCompleted()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadStarted () {
        performUIUpdateOnMain {
            self.activityIndicator.startAnimating()
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdateOnMain {
            self.activityIndicator.stopAnimating()
            self.listTV.reloadData()
        }
    }
    
    func didSelectionLocation(info: StudentInformation) {
        openWithSafari(info.mediaURL)
    }


}
