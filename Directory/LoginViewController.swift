//
//  LoginViewController.swift
//  Directory
//
//  Created by Candice Davis on 8/26/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var tokenKey: String = "tommy"
    var token: String = ""
    var success: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Locksmith.deleteDataForUserAccount(self.tokenKey)
        let (dictionary, _) = Locksmith.loadDataForUserAccount(tokenKey)
        if(dictionary != nil) {
            self.performSegueWithIdentifier("toSchoolsView", sender: self)
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let tokenService = TokenService(newUsername: username.text!, newPassword: password.text!)
        tokenService.getToken() {
            (let newToken) in
            if(newToken != ""){
                self.token = newToken
                _ = Locksmith.saveData([self.tokenKey: self.token], forUserAccount: self.tokenKey)
                dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("toSchoolsView", sender:self)
                }
            } else {
                self.showErrorMessage()
            }
        }
    }
    
    func showErrorMessage() {
        //show an error message
        let alert = UIAlertController(title: "Error", message: "The username or password you have entered is invalid", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
        alert.addAction(alertAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSchoolsView" {
            let vc = segue.destinationViewController as! SchoolsTableViewController
            let (_,_) = Locksmith.loadDataForUserAccount(tokenKey)
            vc.token = token
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

