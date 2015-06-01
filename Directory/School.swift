//
//  School.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class School: NSObject {
    
    var name: String?
    var address: String?
    var phoneNumber: String?
    var enrollment: Int?
    var contacts: [Contact] = []
    
    init(n :String, a :String, p :String, e :Int, c:[Contact]) {
        name = n
        address = a
        phoneNumber = p
        enrollment = e
    }
}
