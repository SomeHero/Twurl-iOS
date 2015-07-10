//
//  Influencer.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 6/21/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import Foundation
import CoreData

class Influencer: NSManagedObject {

    @NSManaged var created_at: NSDate
    @NSManaged var handle: String
    @NSManaged var id: NSNumber
    @NSManaged var twitter_username: String
    @NSManaged var updated_at: NSDate
    @NSManaged var channel: NSManagedObject
    @NSManaged var twurls: NSSet

}
