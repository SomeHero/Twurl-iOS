//
//  TwurlWebViewController.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 7/4/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import FontAwesome_swift
import Social
import MessageUI

class TwurlWebViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var webView: WKWebView
    var twurl: JSON
    
    @IBOutlet
    var webViewFrame:UIView!
    
    @IBOutlet
    var closeButton:UIButton!
    
    @IBOutlet
    var shareWithFacebook:UIButton!
    
    @IBOutlet
    var shareWithTwitter:UIButton!
    
    @IBOutlet
    var shareWithEmail:UIButton!
    
    @IBOutlet
    var shareWithOther:UIButton!
    
    @IBAction func closeButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareWithFacebook(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            let title = twurl["headline"].stringValue
            var messageBody = title.substringToIndex(advance(title.startIndex, 80))
            messageBody += "  "
            messageBody += twurl["url"].stringValue
            
            facebookSheet.setInitialText("Share on Facebook")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func shareWithTwitter(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            let title = twurl["headline"].stringValue
            var messageBody = title.substringToIndex(advance(title.startIndex, 80))
            messageBody += "  "
            messageBody += twurl["url"].stringValue
            
            twitterSheet.setInitialText(messageBody)
    
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func shareWithEmail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self 
        
        //mailComposerVC.setToRecipients()
        mailComposerVC.setSubject(twurl["headline"].stringValue)
        var messageBody = "Thought you'd want to see this...\n\n"
        messageBody += twurl["url"].stringValue
        
        mailComposerVC.setMessageBody(messageBody, isHTML: false)

        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareWithOther(sender: UIButton) {
        let title = twurl["headline"].stringValue
        var textToShare = title.substringToIndex(advance(title.startIndex, 80))

        if let myWebsite = NSURL(string: twurl["url"].stringValue)
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        self.twurl = nil
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Twurl"
        var button = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.Plain, target: self, action: "backClicked")
        
        self.navigationItem.leftBarButtonItem = button
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.closeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        self.closeButton.setTitle(String.fontAwesomeIconWithName(.Times), forState: .Normal)
        
        self.shareWithFacebook.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        self.shareWithFacebook.setTitle(String.fontAwesomeIconWithName(.Facebook), forState: .Normal)
        
        self.shareWithTwitter.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        self.shareWithTwitter.setTitle(String.fontAwesomeIconWithName(.Twitter), forState: .Normal)
        
        self.shareWithEmail.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        self.shareWithEmail.setTitle(String.fontAwesomeIconWithName(.EnvelopeO), forState: .Normal)
        
        self.shareWithOther.titleLabel?.font = UIFont.fontAwesomeOfSize(24)
        self.shareWithOther.setTitle(String.fontAwesomeIconWithName(.ShareSquareO), forState: .Normal)
        
        self.webView.frame = self.webViewFrame.frame
        self.webViewFrame.addSubview(self.webView)
        
        self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let top = NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: self.webViewFrame, attribute: .Top, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: self.webViewFrame, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: self.webViewFrame, attribute: .Width, multiplier: 1, constant: 0)
        
        view.addConstraints([top, height, width])
        
        let url = NSURL(string: twurl["url"].stringValue)
        let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
