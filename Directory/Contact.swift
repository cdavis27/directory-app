//
//  Contact.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var firstName: String!
    var lastName: String!
    var position: String!
    var picture: String!
    
    init(f :String, l :String, p :String, i: String) {
        self.firstName = f
        self.lastName = l
        self.position = p
        self.picture = i
    }
}
