//
//  HTTPWrapper.swift
//  Directory
//
//  Created by Candice Davis on 8/26/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import Foundation

let url = NSURL(string: "http://www.thisisnotarealurl.com")
let session = NSURLSession.sharedSession()

let dataTask = session.dataTaskWithURL(url!, completionHandler: { (data: NSData!, response:NSURLResponse!,
    error: NSError!) -> Void in
    //do something
})