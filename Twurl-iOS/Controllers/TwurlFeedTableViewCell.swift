//
//  TwurlFeedTableViewCell.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 6/21/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit

class TwurlFeedTableViewCell: UITableViewCell {
    
    @IBOutlet
    var wrapperView: UIView!
    
    @IBOutlet
    var headlineLabel: UILabel!
    
    @IBOutlet
    var summaryLabel: UILabel!
    
    @IBOutlet
    var headlineImageView: UIImageView!
    
    @IBOutlet
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet
    var twitterUsernameLabel: UILabel!
    
    @IBOutlet
    var twitterHandleLabel: UILabel!
    
    @IBOutlet
    var twitterProfileImage: UIImageView!
    
    @IBOutlet
    var timestampLabel: UILabel!
    
    @IBOutlet
    var originalTweetLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        self.headlineImageView.image = nil
        self.headlineLabel.text = ""
    }

}
