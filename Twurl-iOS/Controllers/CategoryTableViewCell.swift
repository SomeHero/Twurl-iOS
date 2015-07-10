//
//  CategoryTableViewCell.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 7/7/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet
    var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
