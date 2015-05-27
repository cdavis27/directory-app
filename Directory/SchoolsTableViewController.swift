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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.title = "Schools"
        
        let school1 = School(n:"Mountain View", a:"Orem, Utah", p:"801-651-3294", e:1100)
        let school2 = School(n:"American Fork High", a:"American Fork, Utah", p:"801-651-3294", e:1300)
        let school3 = School(n:"Prove High", a:"Provo, Utah", p:"801-651-3294", e:2000)
        let school4 = School(n:"Lone Peak", a:"Alpine, Utah", p:"801-651-3294", e:900)
        
        // load data from API
        self.schoolsArray += [school1 , school2, school3, school4]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSchoolView" {
            let index = tableView.indexPathForSelectedRow()
            let vc = segue.destinationViewController as! SchoolViewController
            vc.currentSchool = self.schoolsArray[index!.row]
    
        }
    }
}
