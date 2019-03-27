//
//  UserModel.swift
//  On The Map
//
//  Created by leonard on 3/22/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

struct User: Codable{
    let account: Account?
    let session: Session?
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
