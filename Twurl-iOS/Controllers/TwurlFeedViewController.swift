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
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.page_number = 1
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //self.configureTableView()
        
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
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("refreshInvoked"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        var width: CGFloat = UIScreen.mainScreen().bounds.size.width - 100
        
        var titleView: UIView = UIView(frame: CGRectMake(50, 0, width, 44))
        
        var lblTitle: UILabel = UILabel()

        lblTitle.text = "twurl"
        lblTitle.backgroundColor = UIColor.clearColor()
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.font = UIFont(name: "Avenir-Medium", size: 18.0)
        lblTitle.textAlignment = .Center
        lblTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleView.addSubview(lblTitle);
        
        var categoryNameLabel: UILabel = UILabel()

        categoryNameLabel.text = appDelegate.categoryName
        categoryNameLabel.backgroundColor = UIColor.clearColor()
        categoryNameLabel.textColor = UIColor.whiteColor()
        categoryNameLabel.font = UIFont(name: "Avenir-Medium", size: 12.0)
        categoryNameLabel.textAlignment = .Center
        categoryNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleView.addSubview(categoryNameLabel);

        self.navigationItem.titleView = titleView;
    
        titleView.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .Leading, relatedBy: .Equal, toItem: titleView, attribute: .Left, multiplier: 1, constant: -16))
        
        titleView.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .Trailing, relatedBy: .Equal, toItem: titleView, attribute: .Right, multiplier: 1, constant: 0))
        
        titleView.addConstraint(NSLayoutConstraint(item: lblTitle, attribute: .Top, relatedBy: .Equal, toItem: titleView, attribute: .Top, multiplier: 1, constant: 4))
        
        titleView.addConstraint(NSLayoutConstraint(item: categoryNameLabel, attribute: .Leading, relatedBy: .Equal, toItem: titleView, attribute: .Left, multiplier: 1, constant: -16))
        
        titleView.addConstraint(NSLayoutConstraint(item: categoryNameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: titleView, attribute: .Right, multiplier: 1, constant: 0))
        
        titleView.addConstraint(NSLayoutConstraint(item: categoryNameLabel, attribute: .Top, relatedBy: .Equal, toItem: lblTitle, attribute: .Bottom, multiplier: 1, constant: -6))
        
        titleView.addConstraint(NSLayoutConstraint(item: categoryNameLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 18))
        
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
        
        cell.wrapperView.layer.shadowColor = UIColor.grayColor().CGColor
        cell.wrapperView.layer.shadowOffset = CGSizeMake(0, 2)
        cell.wrapperView.layer.shadowOpacity = 0.8
        cell.wrapperView.layer.shadowRadius = 5.0
        
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
        if !self.twurls[indexPath.row]["influencer"]["profile_image_url"].stringValue.isEmpty {
            let url = NSURL(string: self.twurls[indexPath.row]["influencer"]["profile_image_url"].stringValue)!
            
            cell.twitterProfileImage.hnk_setImageFromURL(url, format: Format<UIImage>(name: "original"))
        }
        cell.originalTweetLabel.text = self.twurls[indexPath.row]["original_tweet"].stringValue
        
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_height"].stringValue)?.doubleValue
        let width = NSNumberFormatter().numberFromString(self.twurls[indexPath.row]["headline_image_width"].stringValue)?.doubleValue
        
        var imageHeight = CGFloat(0.0)
        if(height != nil && width != nil) {
            let aspect_ratio = UIScreen.mainScreen().bounds.size.width/CGFloat(width!)
            imageHeight = aspect_ratio*CGFloat(height!)
        } else {
            imageHeight = 0
        }

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let headlineWidth = screenWidth - 20 - 20-10
        
        var headlineHeight = CGFloat(0.0)
        let headline_copy = self.twurls[indexPath.row]["headline"].stringValue

        if(!headline_copy.isEmpty) {
            let options : NSStringDrawingOptions = .UsesLineFragmentOrigin
            var headlineLabelRect = headline_copy.boundingRectWithSize(CGSize(width:Double(headlineWidth), height: DBL_MAX),
            options: options,
            attributes: [NSFontAttributeName: UIFont(name: "Avenir Medium", size: 24)!],
            context: nil).size
        
            headlineHeight = headlineLabelRect.height
        }
        
        
        var originalTweetHeight = CGFloat(0.0)
        let originalTweet = self.twurls[indexPath.row]["original_tweet"].stringValue
        
        let originalTweetWidth = screenWidth - 20 - 50 - 20-10
        
        if(!originalTweet.isEmpty) {
            let options : NSStringDrawingOptions = .UsesLineFragmentOrigin
            var labelRect = originalTweet.boundingRectWithSize(CGSize(width:Double(originalTweetWidth), height: DBL_MAX),
                options: options,
                attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 12)!],
                context: nil).size
            
            originalTweetHeight = labelRect.height
        } else {
            originalTweetHeight = 40
        }
        
        return imageHeight+10.0+headlineHeight+21+16+originalTweetHeight+20+20+20
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
    func refreshInvoked() {
        refresh(viaPullToRefresh: true)
    }
    
    func refresh(viaPullToRefresh: Bool = false) {
        self.page_number = 1
        
        TwurlApiManager.getTwurls(self.category_id, page_number: self.page_number, success: { (response) -> Void in
            self.twurls = SwiftyJSON.JSON(response.arrayObject!)
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            }, failure: { (error) -> Void in
                self.refreshControl?.endRefreshing()
                println("Failed")
        })
    }
}
