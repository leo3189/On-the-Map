//
//  Constants.swift
//  On The Map
//
//  Created by leonard on 3/25/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Udacity {
        static let Scheme = "https"
        static let Host = "www.udacity.com"
        static let Path = "/api"
    }
    
    struct UdacityMethod {
        static let Authentication = "/session"
        static let Users = "/users"
    }
    
    struct UdacityJSONResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let UserKey = "key"
        static let Session = "session"
        static let SessionID = "id"
    }
    
    struct Parse {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let Path = "path"
    }
    
    struct ParseMethod {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    struct ParseJSONResponseKeys {
        static let Results = "results"
    }
    
    struct ParseParameterKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let Where = "where"
        static let Order = "order"
    }
    
    struct ParseParametersValus {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
}
