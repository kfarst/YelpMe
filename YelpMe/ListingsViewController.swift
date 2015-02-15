//
//  ListingsViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class ListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var listingsTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    let consumerKey = "7yDj7L9oeX8jaDPCuyEoAA"
    let consumerSecret = "r45inzud9CcgjwgGJFuL4IO1-9o"
    let token = "rZgBcnMPONDo8v5JGuQIpvAggzcGnvky"
    let secret = "EjD5RcY54PdT_qBjEb4tW4vOJTc"
    
    var searchBar: UISearchBar!
    
    var keywordForSearch = "Restaurants"
    var showDeals = false
    var categoryList: [String] = []
    var categoryFilter = 0
    var showDealsFilter = false
    var radiusRowSelected = 0
    var currentPage = 1
    var sortByFilter = 0
    var sortByRowSelected = 0
    var radiusFilter = 0
    
    var listings : [NSDictionary] = []
    
    var filtersViewController: FiltersViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        
        createSearchBar()
        
        let yelpRed = UIColor(hexString: "#AF0606")
        
        self.navigationController!.navigationBar.configureFlatNavigationBarWithColor(yelpRed)
        
        self.filterButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
        self.filterButton.tintColor = UIColor.whiteColor()
        
        listingsTableView.rowHeight = UITableViewAutomaticDimension
        listingsTableView.estimatedRowHeight = 90.0
        
        searchBar.placeholder = keywordForSearch
        
        //filterButton.addTarget(self, action: "filterButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        
        fetchListings()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
    }
    
    func fetchListings() {
       client().search(self.keywordForSearch,
           categories: self.categoryList,
           dealsFilter: self.showDeals,
           radiusFilter: self.radiusFilter,
           sortByFilter: self.sortByFilter,
           offset: getOffset(),
           limit: 20,
           success: {
               (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
               println(response)
               self.listings += response["businesses"] as [NSDictionary]
               NSLog("Listings count \(self.listings.count)")
               
               // Do any additional setup after loading the view.
               self.listingsTableView.reloadData()
               self.view.endEditing(true);
           }) {
               (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
               println(error)
       }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.keywordForSearch = searchBar.text
        self.currentPage = 1
        self.listings = []
        self.fetchListings()
        searchBar.endEditing(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("Row \(indexPath.row) and section \(indexPath.section)")
        if ((currentPage * 20) - indexPath.row == 5) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                self.currentPage += 1
                self.fetchListings()
            })
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ListingViewCell", forIndexPath: indexPath) as ListingViewCell
        cell.listing = listings[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterOptionsScene" {
            filtersViewController = segue.destinationViewController as FiltersViewController
            
            filtersViewController.delegate = self
            filtersViewController.showDealsSelected = self.showDealsFilter
            filtersViewController.radiusSelected = self.radiusRowSelected
            filtersViewController.sortBySelected = self.sortByRowSelected
            filtersViewController.categoryRowsSelected = self.categoryList
        }
    }
    
    // Delegate methods
    
    func showDealsSelected(selected: Bool) {
        self.showDeals = selected
        filtersViewController.showDealsSelected = self.showDeals
    }
    
    func radiusSelected(distanceInMeters: Int, rowSelected: Int) {
        self.radiusFilter = distanceInMeters
        self.radiusRowSelected = rowSelected
    }
    
    func sortBySelected(sortBy: Int, rowSelected: Int) {
        self.sortByFilter = sortBy
        self.sortByRowSelected = rowSelected
    }
    
    func categorySelected(category: String, selected: Bool) {
        if (selected) {
            self.categoryList.append(category)
            NSLog("Adding category \(category)")
        } else {
            var removeIndex = find(self.categoryList, category)
            if let index = removeIndex {
                NSLog("Removing category \(category)")
                self.categoryList.removeAtIndex(index)
            }
        }
        filtersViewController.categoryRowsSelected = self.categoryList
    }
    
    func searchWithFilterClicked() {
        self.keywordForSearch = searchBar.text
        self.currentPage = 1
        self.listings = []
        self.fetchListings()
        searchBar.endEditing(true)
    }
    
    // Private functions
    
    private func getOffset() -> Int {
       return self.currentPage * 20
    }
    
    private func createSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    private func client() -> YelpClient {
        return YelpClient(consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            accessToken: token,
            accessSecret: secret)
    }
}
