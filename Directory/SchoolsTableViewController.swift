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
        self.navigationItem.title = "SCHOOLS"
        
        let contact1 = Contact(f:"Parker", l:"Lusk", p:"Principal", i:"http://cdmlipowa.pl/wp-content/uploads/2014/03/Person-icon-grey.jpg")
        let contact2 = Contact(f:"Candice", l:"Davis", p:"Principal",i:"")
        let contacts1: [Contact] = [contact1, contact2]
        let contacts2: [Contact] = [contact1]
        
        let school1 = School(n:"Mountain View", a:"848 W 260 S Orem, UT, 84058", p:"8016513642", e:1100, c:contacts1)
        let school2 = School(n:"American Fork High", a:"American Fork, UT", p:"8016513642", e:1300, c:contacts2)
        let school3 = School(n:"Prove High", a:"Provo, UT, USA", p:"8016513642", e:2000, c:contacts1)
        let school4 = School(n:"Lone Peak", a:"Alpine, UT, USA", p:"8016513642", e:900, c:contacts2)
        
        // load data from API
        self.schoolsArray += [school1 , school2, school3, school4]
        // sorts schools alphabetically by school name
        schoolsArray.sort({ $0.name < $1.name })
       
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
//            self.navigationItem.title = ""
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        }
    }
}
