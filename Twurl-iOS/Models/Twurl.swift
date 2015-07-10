//
//  Twurl.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 6/21/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import Foundation
import CoreData

class Twurl: NSManagedObject {

    @NSManaged var created_at: NSDate
    @NSManaged var headline: String
    @NSManaged var headline_image_url: String
    @NSManaged var id: NSNumber
    @NSManaged var updated_at: NSDate
    @NSManaged var url: String
    @NSManaged var summary: String
    @NSManaged var influencer: Influencer

}
