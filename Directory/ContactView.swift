//
//  ContactView.swift
//  Directory
//
//  Created by Candice on 6/1/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class ContactView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    
    var contact: Contact!
    
    convenience init(contact: Contact!, ypos: Int!) {
        self.init(frame: CGRect(x: 0, y: ypos, width: 320, height:88))
        xibSetup()
        
        self.contact = contact
        self.image.layer.cornerRadius = self.image.frame.size.width / 2
        self.image.clipsToBounds = true
        
        self.name.text = contact.firstName + " " + contact.lastName
        self.position.text = contact.position
        
        // checks if there is a img, else uses default
        if(self.contact.picture != "") {
            if let checkedUrl = NSURL(string: self.contact.picture) {
                downloadImage(checkedUrl)
            }
        } else {
            self.image.image = UIImage(named: "monster")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
        self.image.layer.cornerRadius = self.image.frame.size.width / 2
        self.image.clipsToBounds = true
    }
    
    func xibSetup() {
        NSBundle.mainBundle().loadNibNamed("ContactView", owner: self, options: nil)
        self.view.frame = bounds
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(self.view)
    }
    
    // Asynchronously downloads contact picture
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func downloadImage(url:NSURL){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.image.image = UIImage(data: data!)
            }
        }
    }
}
