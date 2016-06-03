//
//  TokenService.swift
//  Directory
//
//  Created by Candice Davis on 8/26/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import Foundation

struct TokenService {
    
    let username: String
    let password: String
    
    init(newUsername: String, newPassword: String) {
        username = newUsername
        password = newPassword
    }
    
    func getToken(completion: (String -> Void)) {
        
        if let directoryURL = NSURL(string: "http://directory.tomjacksonphoto.com/api/authenticate") {
            let networkOperation = NetworkOperation(url: directoryURL)
            
            networkOperation.post(username, password: password) {
                (let JSONDictionary) in
                let currentToken = self.currentTokenFromJSONDictionary(JSONDictionary!)
                print(currentToken)
                completion(currentToken)
            }
            
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func currentTokenFromJSONDictionary(jsonDictionary: [String: AnyObject]) -> String {
        if let token = jsonDictionary["token"] as! String! {
            return token
        } else {
            print("JSON dictionary returned nil for token key")
            return ""
        }
    }
}
