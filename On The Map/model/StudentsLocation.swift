//
//  StudentsLocation.swift
//  On The Map
//
//  Created by leonard on 3/28/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

struct StudentsLocation {
    static var shared = StudentsLocation()
    
    private init() {}
    
    var studentsInformation = [StudentInformation]()
}
