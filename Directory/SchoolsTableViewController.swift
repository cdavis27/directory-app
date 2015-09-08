//
//  SchoolsTableViewController.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit

class SchoolsTableViewController: UITableViewController {
    
    var schoolsArray: [School] = []
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SCHOOLS"
        self.navigationItem.setHidesBackButton(true, animated:true);
        getSchools()
    }
    
    func getSchools() {
        // load data from API
        let directoryService = DirectoryService()
        directoryService.getDirectory(token) {
            (let schools) in
//            self.schoolsArray = schools
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schoolsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.schoolsArray[indexPath.row].name
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSchoolView" {
            let index = tableView.indexPathForSelectedRow()
            let vc = segue.destinationViewController as! SchoolViewController
            vc.currentSchool = self.schoolsArray[index!.row]
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
