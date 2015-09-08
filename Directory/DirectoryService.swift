//
//  DirectoryService.swift
//  Directory
//
//  Created by Candice Davis on 8/25/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import Foundation

struct DirectoryService {
    
    func getDirectory(token: String, completion: (String -> Void)) {
        
        if let directoryURL = NSURL(string: "http://directory.tomjacksonphoto.com/api/schools") {
            let networkOperation = NetworkOperation(url: directoryURL)
            
            networkOperation.downloadJSONFromURL(token) {
                (let JSONDictionary) in
                let currentDirectory = self.currentDirectoryFromJSONDictionary(JSONDictionary)
                println(currentDirectory)
                completion("done")
            }
        } else {
            println("Could not construct a valid URL")
        }
    }
    
    func currentDirectoryFromJSONDictionary(jsonDictionary: [String: AnyObject]?) -> String {
        if let currentDirectoryDictionary = jsonDictionary!["schools"] as? [String: [AnyObject]] {
            return "done"
        } else {
            println("JSON dictionary returned nil for schools key")
            return "done"
        }
    }
}