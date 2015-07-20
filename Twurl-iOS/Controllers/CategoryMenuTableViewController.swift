//
//  CategoryMenuTableViewController.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 7/7/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class CategoryMenuTableViewController: UITableViewController {
    var categories: SwiftyJSON.JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        TwurlApiManager.getCategories({ (response) -> Void in
            println("Success")
            self.categories = response
            
            self.tableView.reloadData()
            }, failure: { (error) -> Void in
                println("Failed")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.categories.count + 1;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryTableViewCell

        if(indexPath.row == 0) {
            cell.categoryLabel.text = "All Articles"
        } else {
            cell.categoryLabel.text = self.categories[indexPath.row-1]["name"].stringValue
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let navController = segue.destinationViewController as! UINavigationController
        let vc = navController.topViewController as! TwurlFeedViewController
        
        let indexPath = self.tableView.indexPathForSelectedRow()!
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(indexPath.row == 0) {
            appDelegate.categoryName = "All Articles"
            vc.category_id = nil
        } else {
            appDelegate.categoryName = self.categories[indexPath.row-1]["name"].stringValue
            vc.category_id = self.categories[indexPath.row-1]["id"].int
        }
    }

}
