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
        
        self.navigationController!.navigationBar.configureFlatNavigationBar(with: yelpRed)
        
        filterButton.configureFlatButton(with: UIColor.pomegranate(), highlightedColor: UIColor.alizarin(), cornerRadius: 5.0)
        filterButton.tintColor = UIColor.white
        
        listingsTableView.rowHeight = UITableViewAutomaticDimension
        listingsTableView.estimatedRowHeight = 90.0
        listingsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        searchBar.placeholder = keywordForSearch
        
        fetchListings(true)
        
        
        self.listingsTableView.reloadSections(IndexSet(0..<self.listingsTableView.numberOfSections), with: .none)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        searchBar.endEditing(true)
    }
    
    func fetchListings(_ showProgress: Bool = false) {
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
                (operation: AFHTTPRequestOperation?, response: Any?) -> Void in
                
                if let json = response as? AnyObject {
                    self.listings += json["businesses"] as! [NSDictionary]
                
                    self.listingsTableView.reloadData()
                    self.view.endEditing(true);
                }
                
                if showSpinner {
                    SVProgressHUD.dismiss()
                }
            }, failure: {
                (operation: AFHTTPRequestOperation?, error: Error?) -> Void in
                print(error?.localizedDescription)
                
                if showSpinner {
                    SVProgressHUD.dismiss()
                }
            })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.keywordForSearch = searchBar.text!
        self.currentPage = 1
        self.listings = []
        self.fetchListings()
        searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((currentPage * 20) - indexPath.row == 5) {
            DispatchQueue.global( priority: DispatchQueue.GlobalQueuePriority.low).async(execute: {
                self.currentPage += 1
                self.fetchListings()
            })
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingViewCell", for: indexPath) as! ListingViewCell
        cell.listing = listings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterOptionsScene" {
            filtersViewController = segue.destination as! FiltersViewController
            
            filtersViewController.delegate = self
            filtersViewController.showDealsSelected = self.showDealsFilter
            filtersViewController.radiusSelected = self.radiusRowSelected
            filtersViewController.sortBySelected = self.sortByRowSelected
            filtersViewController.categoriesSelected = self.categoryFilter
        }
    }
    
    // Delegate methods
    
    func showDealsSelected(_ selected: Bool) {
        self.showDealsFilter = selected
        filtersViewController.showDealsSelected = self.showDealsFilter
    }
    
    func radiusSelected(_ distanceInMeters: Int, rowSelected: Int) {
        self.radiusFilter = distanceInMeters
        self.radiusRowSelected = rowSelected
    }
    
    func sortBySelected(_ sortBy: Int, rowSelected: Int) {
        self.sortByFilter = sortBy
        self.sortByRowSelected = rowSelected
    }
    
    func categorySelected(_ category: String, selected: Bool) {
        if (selected) {
            self.categoryFilter.append(category)
            NSLog("Adding category \(category)")
        } else {
            let removeIndex = self.categoryFilter.index(of: category)
            if let index = removeIndex {
                NSLog("Removing category \(category)")
                self.categoryFilter.remove(at: index)
            }
        }
        filtersViewController.categoriesSelected = self.categoryFilter
    }
    
    func searchWithFilterClicked() {
        self.keywordForSearch = searchBar.text!
        self.currentPage = 1
        self.listings = []
        self.fetchListings(true)
        searchBar.endEditing(true)
    }
    
    // Private functions
    
    fileprivate func getOffset() -> Int {
       return self.currentPage * 20
    }
    
    fileprivate func createSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    fileprivate func client() -> YelpClient {
        return YelpClient(consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            accessToken: token,
            accessSecret: secret)
    }
}
