//
//  Category.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 6/21/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var channels: NSSet

}
