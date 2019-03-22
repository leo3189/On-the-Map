//
//  ClientApi.swift
//  On The Map
//
//  Created by leonard on 3/22/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation

class ClientApi {
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.httpBody = try! JSONEncoder().encode(body)
        request.httpBody = body.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ResponseType.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: "https://www.udacity.com/api/session")
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: url!, responseType: User.self, body: body) { response, error in
            if let response = response {
                print("response \(response)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}
