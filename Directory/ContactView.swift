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
    
    convenience init(contact: Contact!) {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.contact = contact
        self.name.text = contact.firstName! + " " + contact.lastName!
        self.position.text = contact.position
        
        NSBundle.mainBundle().loadNibNamed("ContactView", owner: self, options: nil)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("ContactView", owner: self, options: nil)
        self.addSubview(self.view)
        
        self.image.layer.cornerRadius = self.image.frame.size.width / 2
        self.image.clipsToBounds = true
    }
    
//    func xibSetup() {
//        self.view = loadViewFromNib()
//        
//        // use bounds not frame or it'll be offset
//        view.frame = bounds
//        
//        // Make the view stretch with containing view
//        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//        
//        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        self.addSubview(self.view);
//    }
    

}
