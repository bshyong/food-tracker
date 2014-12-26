//
//  DataController.swift
//  FoodTracker
//
//  Created by Ben on 12/25/14.
//  Copyright (c) 2014 Common Sense Labs. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class DataController {
  
  class func jsonAsUSDAIdAndNameSearchResults (json : NSDictionary) -> [(name: String, idValue: String)] {
    var usdaItemsSearchResults:[(name : String, idValue: String)] = []
    var searchResult: (name: String, idValue : String)

    if json["hits"] != nil {
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      for itemDictionary in results {
        if itemDictionary["_id"] != nil {
          if itemDictionary["fields"] != nil {
            let fieldsDictionary = itemDictionary["fields"] as NSDictionary
            if fieldsDictionary["item_name"] != nil {
              let idValue:String = itemDictionary["_id"]! as String
              let name:String = fieldsDictionary["item_name"]! as String
              searchResult = (name : name, idValue : idValue)
              usdaItemsSearchResults += [searchResult]
            }
          }
        }
      }
    }
    return usdaItemsSearchResults
  }
}

