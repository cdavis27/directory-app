//
//  School.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class School: NSObject {
    
    var name: String!
    var address: [String: String]
//    [street: String, city: String, state: String, zip: String]
    var phoneNumber: String!
    var enrollment: Int!
    var contacts: [Contact]
//    [[name: String, position: String, phone: String]]
    
    init(n :String, a :[String: String], p :String, e :Int, c:[Contact]) {
        self.name = n
        self.address = a
        self.phoneNumber = p
        self.enrollment = e
        self.contacts = c
    }
    
//    override init() {
    
//    }
}
