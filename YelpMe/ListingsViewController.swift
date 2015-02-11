//
//  ListingsViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit
import Dollar

class ListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var listingsTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    let consumerKey = "7yDj7L9oeX8jaDPCuyEoAA"
    let consumerSecret = "r45inzud9CcgjwgGJFuL4IO1-9o"
    let token = "rZgBcnMPONDo8v5JGuQIpvAggzcGnvky"
    let secret = "EjD5RcY54PdT_qBjEb4tW4vOJTc"
    
    var searchBar: UISearchBar!
    
    var searchKeyword = "Restaurants"
    var categoryList: [String] = []
    var dealsFilter = false
    var distanceFilterRowSelected = 0
    var currentPage = 1
    var sortByFilter = 0
    var sortByFilterRowSelected = 0
    var radiusFilter = 0
    
    var listings : [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listingsTableView.delegate = self
        listingsTableView.dataSource = self
        
        createSearchBar()
        customizeNavigationBar()
        
        listingsTableView.rowHeight = UITableViewAutomaticDimension
        listingsTableView.estimatedRowHeight = 89.0
        
        //self.listingsTableView.registerClass(ListingViewCell.classForCoder(), forCellReuseIdentifier: "ListingViewCell")
        
        fetchListings()
    }
    
    func fetchListings() {
        client().search(self.searchKeyword,
            categories: self.categoryList,
            dealsFilter: self.dealsFilter,
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
    
    private func customizeNavigationBar() {
        let yelpRed = UIColor(hexString: "#AF0606")
        
        self.navigationController!.navigationBar.configureFlatNavigationBarWithColor(yelpRed)
        
        self.filterButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
        self.filterButton.tintColor = UIColor.whiteColor()
    }
}
