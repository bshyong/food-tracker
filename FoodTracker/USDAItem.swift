//
//  USDAItem.swift
//  FoodTracker
//
//  Created by Ben on 12/25/14.
//  Copyright (c) 2014 Common Sense Labs. All rights reserved.
//

import Foundation
import CoreData

@objc (USDAItem)
class USDAItem: NSManagedObject {

    @NSManaged var calcium: String
    @NSManaged var carbohydrate: String
    @NSManaged var cholesterol: String
    @NSManaged var dateAdded: NSDate
    @NSManaged var energy: String
    @NSManaged var idValue: String
    @NSManaged var vitaminC: String
    @NSManaged var sugar: String
    @NSManaged var protein: String
    @NSManaged var fatTotal: String
    @NSManaged var name: String

}
