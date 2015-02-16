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
    var categoryFilter: [String] = []
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
        
        filterButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
        filterButton.tintColor = UIColor.whiteColor()
        
        listingsTableView.rowHeight = UITableViewAutomaticDimension
        listingsTableView.estimatedRowHeight = 90.0
        listingsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        searchBar.placeholder = keywordForSearch
        
        fetchListings(showProgress: true)
        
        self.listingsTableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.listingsTableView.numberOfSections())), withRowAnimation: .None)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
    }
    
    func fetchListings(showProgress: Bool = false) {
        let showSpinner = showProgress
        
        if showSpinner {
            SVProgressHUD.show()
        }
        
        client().search(self.keywordForSearch,
            categories: self.categoryFilter,
            dealsFilter: self.showDealsFilter,
            radiusFilter: self.radiusFilter,
            sortByFilter: self.sortByFilter,
            offset: getOffset(),
            limit: 20,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                self.listings += response["businesses"] as [NSDictionary]
                
                self.listingsTableView.reloadData()
                self.view.endEditing(true);
                
                if showSpinner {
                    SVProgressHUD.dismiss()
                }
            }) {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                
                if showSpinner {
                    SVProgressHUD.dismiss()
                }
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
            filtersViewController.categoriesSelected = self.categoryFilter
        }
    }
    
    // Delegate methods
    
    func showDealsSelected(selected: Bool) {
        self.showDealsFilter = selected
        filtersViewController.showDealsSelected = self.showDealsFilter
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
            self.categoryFilter.append(category)
            NSLog("Adding category \(category)")
        } else {
            var removeIndex = find(self.categoryFilter, category)
            if let index = removeIndex {
                NSLog("Removing category \(category)")
                self.categoryFilter.removeAtIndex(index)
            }
        }
        filtersViewController.categoriesSelected = self.categoryFilter
    }
    
    func searchWithFilterClicked() {
        self.keywordForSearch = searchBar.text
        self.currentPage = 1
        self.listings = []
        self.fetchListings(showProgress: true)
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
