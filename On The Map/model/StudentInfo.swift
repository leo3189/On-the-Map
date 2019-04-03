//
//  StudentInfo.swift
//  On The Map
//
//  Created by leonard on 3/28/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

//struct StudentInfo: Codable {
//    let user: U
//}
//
//struct U: Codable {
//    let name: String
//    enum CodingKeys: String, CodingKey {
//        case name = "nickname"
//    }
//}

struct StudentInfo {
    let name: String?
    
    init(_ dict: [String: AnyObject]) {
        self.name = dict["nickname"] as? String ?? ""
    }
}
