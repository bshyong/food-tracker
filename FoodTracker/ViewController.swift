//
//  ViewController.swift
//  FoodTracker
//
//  Created by Benjamin Shyong on 12/22/14.
//  Copyright (c) 2014 Common Sense Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

  let kAppId = "ec683173"
  let kAppKey = "a9cea6fe8625d26caadc9fba5d39c46b"
  
  @IBOutlet weak var tableView: UITableView!

  var searchController: UISearchController!
  var dataController = DataController()
  
  var suggestedSearchFoods:[String] = []
  var filteredSuggestedSearchFoods:[String] = []
  var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
  var jsonResponse:NSDictionary!
  var apiSearchForFoods:[(name: String, idValue: String)] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.searchController = UISearchController(searchResultsController: nil)
    self.searchController.searchResultsUpdater = self
    self.searchController.dimsBackgroundDuringPresentation = false
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)
    
    // update the tableview header with the search bar
    self.tableView.tableHeaderView = self.searchController.searchBar
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
    
    // gives access to callbacks from searchBar
    self.searchController.searchBar.delegate = self
    // ensure the search results controller is presented inside the view controller
    self.definesPresentationContext = true
    
    self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicken breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDataSource
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
    var foodName : String
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex

    if selectedScopeButtonIndex == 0 {
      if self.searchController.active {
        foodName = filteredSuggestedSearchFoods[indexPath.row]
      }
      else {
        foodName = suggestedSearchFoods[indexPath.row]
      }
    }
    else if selectedScopeButtonIndex == 1 {
      foodName = apiSearchForFoods[indexPath.row].name
    }
    else {
      foodName = ""
    }
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    if selectedScopeButtonIndex == 0 {
      if self.searchController.active {
        return self.filteredSuggestedSearchFoods.count
      }
      else {
        return self.suggestedSearchFoods.count
      }
    }
    else if selectedScopeButtonIndex == 1 {
      return self.apiSearchForFoods.count
    }
    else {
      return 0
    }
  }
  
  // MARK: UITableViewDelegate
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    if selectedScopeButtonIndex == 0 {
      var searchFoodName:String
      if self.searchController.active {
        searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
      }
      else {
        searchFoodName = suggestedSearchFoods[indexPath.row]
      }
      self.searchController.searchBar.selectedScopeButtonIndex = 1
      makeRequest(searchFoodName)
    }
    else if selectedScopeButtonIndex == 1 {
      let idValue = apiSearchForFoods[indexPath.row].idValue
      self.dataController.saveUSDAItemForId(idValue, json: self.jsonResponse)
    }
    else if selectedScopeButtonIndex == 2 {
    }
  }

  // MARK: UISearchResultsUpdating
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchString = self.searchController.searchBar.text
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
    self.tableView.reloadData()
  }

  func filterContentForSearch (searchText: String, scope: Int) {
    self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food : String) -> Bool in
      var foodMatch = food.rangeOfString(searchText)
      return foodMatch != nil
    })
  }
  
  //MARK - UISearchBarDelegate
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.searchController.searchBar.selectedScopeButtonIndex = 1
    makeRequest(searchBar.text)
  }

  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    self.tableView.reloadData()
  }
  
  func makeRequest (searchString : String) {
    
    var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    var params = [
      "appId" : kAppId,
      "appKey" : kAppKey,
      "fields" : ["item_name", "brand_name", "keywords", "usda_fields"],
      "limit"  : "50",
      "query"  : searchString,
      "filters": ["exists":["usda_fields": true]]]
    var error: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in

      var conversionError: NSError?
      var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
      
      if conversionError != nil {
        println(conversionError!.localizedDescription)
        let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Error in Parsing \(errorString)")
      }
      else {
        if jsonDictionary != nil {
          self.jsonResponse = jsonDictionary!
          self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
          // reload the view on the main thread
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
          })
        }
        else {
          let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
          println("Error Could not Parse JSON \(errorString)")
        }                
      }
    })
    task.resume()
  }

}

