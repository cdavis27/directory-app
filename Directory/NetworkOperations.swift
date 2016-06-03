//
//  NetworkOperations.swift
//  Directory
//
//  Created by Candice Davis on 8/25/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]? -> Void)
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func post(username: String, password: String, completion: JSONDictionaryCompletion) {
        let request = NSMutableURLRequest(URL: queryURL)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonString = "{\"username\":\"" + username + "\",\"password\":\"" + password + "\", \"ios\":true}"
        let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        request.HTTPBody = data
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // 2. Create JSON object with data
                    let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        }
        
        task.resume()
    }
    
    func downloadJSONFromURL(token: String, completion: JSONDictionaryCompletion) {
        let request = NSMutableURLRequest(URL: queryURL)
        request.addValue(token, forHTTPHeaderField: "x-access-token")
        
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()

        
        
//        let dataTask = session.dataTaskWithRequest(request) {
//            (let data, let response, let error) in
//            
//            // 1. Check HTTP response for successful GET request
//            if let httpResponse = response as? NSHTTPURLResponse {
//                switch httpResponse.statusCode {
//                case 200:
//                    // 2. Create JSON object with data
//                    var data = httpResponse.data
//                    let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! [String: AnyObject]
//                    completion(jsonDictionary)
//                default:
//                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
//                }
//            } else {
//                print("Error: Not a valid HTTP response")
//            }
//        }
        
//        dataTask.resume()
    }
}