//
//  ClientApi.swift
//  On The Map
//
//  Created by leonard on 3/22/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

class ClientApi {
    
    class func taskForPOSTRequest(url: URL, body: String, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.httpBody = try! JSONEncoder().encode(body)
        request.httpBody = body.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                return
            }
            
            print("Data: \(data)")
           
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "https://www.udacity.com/api/session")
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: url!, body: body) { response, error in
            if let response = response {
                print("response \(response)")
                completion(true, nil)
            } else {
                print("Login api error")
                completion(false, error)
            }
        }
    }
    
}
