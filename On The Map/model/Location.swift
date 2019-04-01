//
//  Location.swift
//  On The Map
//
//  Created by leonard on 4/1/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

struct Location: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        
        if let lastName = lastName {
            if name.isEmpty {
                 name = lastName
            } else {
                name += "\(lastName)"
            }
        }
        
        if name.isEmpty {
            name = "No name provided"
        }
        
        return name
    }
}
