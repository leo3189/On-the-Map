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
    var userKey = ""
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
            
            guard let data = data else {
                sendError("No data was returned by the request")
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
    
    func delete(
        _ method: String,
        parameters: [String: AnyObject],
        apiType: APITpye = .udacity,
        completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: buildURL(parameters, withPathExtension: method, apiType: apiType))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        showActivityIndicator(true)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                self.showActivityIndicator(false)
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "DELETE", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200..<200:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            guard let data = data else {
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
    
    func put(
        _ method: String,
        parameters: [String: AnyObject],
        requestHeaderParameters: [String: AnyObject]? = nil,
        jsonBody: String,
        apiType: APITpye = .udacity,
        completion: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let request = NSMutableURLRequest(url: buildURL(parameters, withPathExtension: method, apiType: apiType))
        request.httpMethod = "PUT"
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
                completion(nil, NSError(domain: "put", code: 1, userInfo: userInfo))
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
                sendError("Please check your credentials and try again")
            case 200..<299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            if apiType == .udacity {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            self.showActivityIndicator(false)
            
            completion(newData, nil)
        }
        
        task.resume()
        return task
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
        print("URL: \(components.url!)")
        return components.url!
    }
    
    private func convertData(_ data: Data, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parseResult: AnyObject! = nil
        do {
            parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as json: \(data)"]
            completionHandler(nil, NSError(domain: "convertData", code: 1, userInfo: userInfo))
        }
        
        completionHandler(parseResult, nil)
    }
    
    private func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }
}

extension ClientApi {
    
    func login(userEmail: String, userPassword: String, completion: @escaping (_ success: Bool, _ errorStr: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}"
        _ = post(Constants.UdacityMethod.Authentication, parameters: [:], jsonBody: jsonBody, completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(false, error.localizedDescription)
            } else {
                let userSessionData = self.parseUserSession(data: data)
                print("Session: \(userSessionData)")
                if let sessionData = userSessionData.0 {
                    guard let account = sessionData.account, account.registered == true else {
                        completion(false, "Login Failed, User not registered.")
                        return
                    }
                    
                    guard let userSession = sessionData.session else {
                        completion(false, "Login Failed, no session to the user credentials provided.")
                        return
                    }
                    
                    self.userKey = account.key
                    self.sessionID = userSession.id
                    completion(true, nil)
                } else {
                    completion(false, userSessionData.1!.localizedDescription)
                    self.sessionID = nil
                }
            }
        })
    }
    
    func logout(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        _ = delete(Constants.UdacityMethod.Authentication, parameters: [:], completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(false, error)
            } else {
                let sessionData = self.parseSession(data: data)
                if let _ = sessionData.0 {
                    self.userKey = ""
                    self.sessionID = ""
                    completion(true, nil)
                } else {
                    completion(false, sessionData.1!)
                }
            }
        })
    }
    
    func parseUserSession(data: Data?) -> (User?, NSError?){
        var studentLocation: (userSession: User?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                studentLocation.userSession = try jsonDecoder.decode(User.self, from: data)
            }
        } catch {
            print("Could not parse the data as json: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey: error]
            studentLocation.error = NSError(domain: "parseUserSession", code: 1, userInfo: userInfo)
        }
        return studentLocation
    }
    
    func parseSession(data: Data?) -> (Session?, Error?) {
        var sessionData: (session: Session?, error: Error?) = (nil, nil)
        do {
            struct SessionData: Codable {
                let session: Session
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                sessionData.session = try jsonDecoder.decode(SessionData.self, from: data).session
            }
        } catch {
            print(error)
            sessionData.error = error
        }
        return sessionData
    }
    
    func parseStudentInfo(data: Data?) -> (StudentInfo?, NSError?) {
        var response: (StudentInfo: StudentInfo?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                response.StudentInfo = try jsonDecoder.decode(StudentInfo.self, from: data)
            }
        } catch {
            print("Could not parse the data as JSON: \(error.localizedDescription)")
            let userInfo = [NSLocalizedDescriptionKey: error]
            response.error = NSError(domain: "parseStudentInfo", code: 1, userInfo: userInfo)
        }
        return response
    }
    
    func studentInfo(completion: @escaping (_ result: StudentInfo?, _ error: NSError?) -> Void) {
        let url = Constants.UdacityMethod.Users + "\(userKey)"
        _ = get(url, parameters: [:], completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(nil, error)
            } else {
                let response = self.parseStudentInfo(data: data)
                if let info = response.0 {
                    completion(info, nil)
                } else {
                    completion(nil, response.1)
                }
            }
        })
    }
    
    func studentsInformation(completion: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Order: "-updatedAt" as AnyObject]
        _ = get(Constants.ParseMethod.StudentLocation, parameters: params, apiType: .parse, completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(nil, error)
            } else {
                if let data = data {
                    self.convertData(data, completionHandler: { (jsonDoc, error) in
                        var students = [StudentInformation]()
                        if let results = jsonDoc?[Constants.ParseJSONResponseKeys.Results] as? [[String: AnyObject]] {
                            for doc in results {
                                students.append(StudentInformation(doc))
                            }
                            completion(students, nil)
                            return
                        }
                        let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSOn: \(data)"]
                        completion(students, NSError(domain: "studentsInformation", code: 1, userInfo: userInfo))
                    })
                }
            }
        })
    }
    
    func studentInformation(completion: @escaping (_ result: StudentInformation?, _ error: NSError?) -> Void) {
        let params = [Constants.ParseParameterKeys.Where: "{\"uniqueKey\":\(userKey)\"}" as AnyObject]
        _ = get(Constants.ParseMethod.StudentLocation, parameters: params, apiType: .parse, completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(nil, error)
            } else {
                if let data = data {
                    self.convertData(data, completionHandler: { (jsonDoc, error) in
                        if let results = jsonDoc?[Constants.ParseJSONResponseKeys.Results] as? [[String: AnyObject]] {
                            if let studentInformation = results.first {
                                completion(StudentInformation(studentInformation), nil)
                                return
                            }
                            completion(nil, nil)
                        }
                        let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
                        completion(nil, NSError(domain: "studentInformation", code: 1, userInfo: userInfo))
                    })
                }
            }
        })
    }
    
    func postStudentLocation(info: StudentInformation, completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey: Constants.ParseParametersValus.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValus.ApplicationID
        ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        _ = post(Constants.ParseMethod.StudentLocation, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse, completionHandler: { (data, error) in
            if let error = error {
                print(error)
                completion(false, error)
            } else {
                struct Response: Codable {
                    let createdAt: String?
                    let objectId: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let  response = response, response.createdAt != nil {
                            completion(true, nil)
                        }
                    }
                } catch {
                    let msg =  "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey: msg]
                    completion(false, NSError(domain: "postStudentLocation", code: 1, userInfo: userInfo))
                }
            }
        })

    }
    
    func updateStudentLocation(info: StudentInformation, completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let paramHeaders = [
            Constants.ParseParameterKeys.APIKey: Constants.ParseParametersValus.APIKey,
            Constants.ParseParameterKeys.ApplicationID: Constants.ParseParametersValus.ApplicationID
        ] as [String: AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(info.uniqueKey)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
        
        let url = Constants.ParseMethod.StudentLocation + "/" + (info.locationID ?? "")
        
        _ = put(url, parameters: [:], requestHeaderParameters: paramHeaders, jsonBody: jsonBody, apiType: .parse, completion: { (data, error) in
            if let error = error {
                print(error)
                completion(false, error)
            } else {
                struct Response: Codable {
                    let updatedAt: String?
                }
                
                var response: Response!
                do {
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        response = try jsonDecoder.decode(Response.self, from: data)
                        if let response = response, response.updatedAt != nil {
                            completion(true, nil)
                        }
                    }
                } catch {
                    let msg = "Could not parse the data as JSON: \(error.localizedDescription)"
                    print(msg)
                    let userInfo = [NSLocalizedDescriptionKey: msg]
                    completion(false, NSError(domain: "updateStudentLocation", code: 1, userInfo: userInfo))
                }
            }
        })
    }
}
