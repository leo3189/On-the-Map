//
//  ClientApi.swift
//  On The Map
//
//  Created by leonard on 3/22/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation
import UIKit

class ClientApi: NSObject {
    
    enum APITpye {
        case udacity
        case parse
    }
    
    var session = URLSession.shared
    
    var sessionID: String? = nil
    var useKey = ""
    var userName = ""
    
    override init() {
        super.init()
    }
    
    class func shared() -> ClientApi {
        struct Singleton {
            static var shared = ClientApi()
        }
        return Singleton.shared
    }
    
    func get(
        _ method: String,
        parameters: [String: AnyObject],
        apiType: APITpye = .udacity,
        completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: buildURL(parameters, withPathExtension: method, apiType: apiType))
        
        if apiType == .parse {
            request.addValue(Constants.ParseParametersValus.APIKey, forHTTPHeaderField: Constants.ParseParameterKeys.APIKey)
            request.addValue(Constants.ParseParametersValus.ApplicationID, forHTTPHeaderField: Constants.ParseParametersValus.ApplicationID)
        }
        
        showActivityIndicator(true)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                self.showActivityIndicator(false)
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "get", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else{
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            if apiType == .udacity {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            self.showActivityIndicator(false)
            
            completionHandler(newData, nil)
        }
        task.resume()
        
        return task
    }
    
    func post(
        _ method: String,
        parameters: [String: AnyObject],
        requestHeaderParameters: [String: AnyObject]? = nil,
        jsonBody: String,
        apiType: APITpye = .udacity,
        completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: buildURL(parameters, withPathExtension: method, apiType: apiType))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headersParam = requestHeaderParameters {
            for (key, value) in headersParam {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        showActivityIndicator(true)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                self.showActivityIndicator(false)
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "post", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200..<299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
        }
        
    }
    
    private func buildURL(_ parameters: [String: AnyObject], withPathExtension: String? = nil, apiType: APITpye = .udacity) -> URL {
        var components = URLComponents()
        components.scheme = apiType == .udacity ? Constants.Udacity.Scheme : Constants.Parse.Scheme
        components.host = apiType == .udacity ? Constants.Udacity.Host : Constants.Parse.Host
        components.path = (apiType == .udacity ? Constants.Udacity.Path : Constants.Parse.Path) + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
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
