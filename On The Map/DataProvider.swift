//
//  DataProvider.swift
//  On The Map
//
//  Created by leonard on 4/3/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation
import UIKit

protocol LocationSelectionDelegate: class {
    func didSelectionLocation(info: StudentInformation)
}

class DataProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: LocationSelectionDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocation.shared.studentsInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTVCell.identifier, for: indexPath) as! LocationTVCell
        
        cell.configWith(StudentsLocation.shared.studentsInformation[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectionLocation(info: StudentsLocation.shared.studentsInformation[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
