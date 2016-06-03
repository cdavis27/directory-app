//
//  DirectoryService.swift
//  Directory
//
//  Created by Candice Davis on 8/25/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import Foundation

struct DirectoryService {
    
    
    func getDirectory(token: String, completion: ([String: AnyObject] -> Void)) {
        
        if let directoryURL = NSURL(string: "http://directory.tomjacksonphoto.com/api/schools") {
            let networkOperation = NetworkOperation(url: directoryURL)
            
            networkOperation.downloadJSONFromURL(token) {
                (let JSONDictionary) in
                let currentDirectory = self.currentDirectoryFromJSONDictionary(JSONDictionary)
//                print(currentDirectory)
                completion(currentDirectory)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func currentDirectoryFromJSONDictionary(jsonDictionary: [String: AnyObject]?) -> [String: AnyObject] {
        if (jsonDictionary!["schools"] as? [String: [AnyObject]]) != nil {
            return jsonDictionary!
        } else {
            print("JSON dictionary returned nil for schools key")
            return jsonDictionary!
        }
    }
}