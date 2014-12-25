//
//  ViewController.swift
//  FoodTracker
//
//  Created by Benjamin Shyong on 12/22/14.
//  Copyright (c) 2014 Common Sense Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

  @IBOutlet weak var tableView: UITableView!
  var searchController: UISearchController!
  
  var suggestedSearchFoods:[String] = []
  var filteredSuggestedSearchFoods:[String] = []
  var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
  
  
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
    if self.searchController.active {
      foodName = filteredSuggestedSearchFoods[indexPath.row]
    }
    else {
      foodName = suggestedSearchFoods[indexPath.row]
    }
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.searchController.active {
      return self.filteredSuggestedSearchFoods.count
    }
    else {
      return self.suggestedSearchFoods.count
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

}

