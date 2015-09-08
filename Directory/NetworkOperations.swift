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
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    println("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                println("Error: Not a valid HTTP response")
            }
        }
        
        task.resume()
    }
    
    func downloadJSONFromURL(token: String, completion: JSONDictionaryCompletion) {
        let request = NSMutableURLRequest(URL: queryURL)
        request.addValue(token, forHTTPHeaderField: "x-access-token")
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // 2. Create JSON object with data
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
                    completion(jsonDictionary)
                default:
                    println("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
            } else {
                println("Error: Not a valid HTTP response")
            }
        }
        
        dataTask.resume()
    }
}