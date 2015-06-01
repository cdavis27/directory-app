//
//  Contact.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var firstName: String?
    var lastName: String?
    var position: String?
//    var picture
    
    init(f :String, l :String, p :String) {
        firstName = f
        lastName = l
        position = p
    }
    
    func setupLayout() {
        
    }
}
