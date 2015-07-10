//
//  TwurlFeedViewController.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 7/3/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import SWRevealViewController
import NSDate_TimeAgo
import DateTools
import UIScrollView_InfiniteScroll

class TwurlFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var category_id :Int?
    var page_number = 0
    var selectedIndex = 0
    
    @IBOutlet
    var menuButton:UIBarButtonItem!
 
    @IBOutlet
    var tableView: UITableView!
    
    var twurls: SwiftyJSON.JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page_number = 1
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //self.configureTableView()
        
        self.tableView.contentInset = UIEdgeInsetsZero
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Set custom indicator margin
        self.tableView.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let tableView = scrollView as! UITableView

            self?.page_number += 1
            
            TwurlApiManager.getTwurls(self?.category_id, page_number: self?.page_number, success: { (response) -> Void in
                self?.twurls = SwiftyJSON.JSON(self!.twurls.arrayObject! + response.arrayObject!)
                
                self?.tableView.reloadData()
                }, failure: { (error) -> Void in
                    println("Failed")
            })
            
            tableView.finishInfiniteScroll()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.configureTableView()
        
        TwurlApiManager.getTwurls(self.category_id, page_number: self.page_number, success: { (response) -> Void in
            self.twurls = response
            
            self.tableView.reloadData()
            }, failure: { (error) -> Void in
                println("Failed")
        })
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.twurls.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwurlItem", forIndexPath: indexPath) as! TwurlFeedTableViewCell
        
        let height = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_height"].stringValue)?.doubleValue
        let width = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_width"].stringValue)?.doubleValue
        
        var new_height = CGFloat(0.0)
        if(height != nil && width != nil) {
            let aspect_ratio = UIScreen.mainScreen().bounds.size.width/CGFloat(width!)
            new_height = aspect_ratio*CGFloat(height!)
        } else {
            new_height = 0
        }
        if !self.twurls[indexPath.row]["headline_image_url"].stringValue.isEmpty {
            let url = NSURL(string: self.twurls[indexPath.row]["headline_image_url"].stringValue)!
        
            cell.headlineImageView.hnk_setImageFromURL(url, format: Format<UIImage>(name: "original"))
            cell.imageViewHeightConstraint.constant = new_height
        } else {
            cell.imageViewHeightConstraint.constant = 0
        }
        cell.headlineLabel.text = self.twurls[indexPath.row]["headline"].stringValue
        cell.twitterUsernameLabel.text = self.twurls[indexPath.row]["influencer"]["twitter_username"].stringValue
        cell.twitterHandleLabel.text = self.twurls[indexPath.row]["influencer"]["handle"].stringValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.dateFromString(self.twurls[indexPath.row]["created_at"].stringValue) {
            cell.timestampLabel.text = date.timeAgoSinceNow()
        }
        
        //cell.headlineLabel.preferredMaxLayoutWidth = self.view.bounds.width
        //cell.summaryLabel.text = self.twurls[indexPath.row]["summary"].string
        //cell.summaryLabel.preferredMaxLayoutWidth = self.view.bounds.width
        
        //cell.contentView.setNeedsLayout()
        //cell.contentView.layoutIfNeeded()
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        
        self.performSegueWithIdentifier("ShowArticle", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_height"].stringValue)?.doubleValue
        let width = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_width"].stringValue)?.doubleValue
        
        var new_height = CGFloat(0.0)
        if(height != nil && width != nil) {
            let aspect_ratio = UIScreen.mainScreen().bounds.size.width/CGFloat(width!)
            new_height = aspect_ratio*CGFloat(height!)
        } else {
            new_height = 0
        }

        let headline_copy = self.twurls[indexPath.row]["headline"].stringValue

        if(!headline_copy.isEmpty) {
            let options : NSStringDrawingOptions = .UsesLineFragmentOrigin
            var headlineLabelRect = headline_copy.boundingRectWithSize(CGSize(width:280, height: DBL_MAX),
            options: options,
            attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 14)!],
            context: nil).size
        
            return CGFloat(new_height)+10.0+headlineLabelRect.height+80.0
        }
        
        return new_height + 100.0
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    func configureTableView() {
        self.tableView.estimatedRowHeight = 460.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = (segue.destinationViewController as! TwurlWebViewController)
    
        viewController.twurl = self.twurls[self.selectedIndex]
    }
}
