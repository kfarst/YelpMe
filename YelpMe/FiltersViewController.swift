//
//  FiltersViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate
{
    func dealsCategorySelected(selected: Bool)
    func distanceCategorySelected(distanceInMeters: Int, rowSelected: Int)
    func sortByCategorySelected(sortBy: Int, rowSelected: Int)
    func generalCategorySelected(category: String, selected: Bool)
    func filterSearchClicked()
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let delegate: FiltersViewControllerDelegate?

    let filters = ["Category", "Sort", "Radius", "Deals"]

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        customizeNavigationBar()
        
        self.filterTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("OptionSectionHeaderViewCell") as OptionSectionHeaderViewCell
        cell.sectionHeaderLabel.text = filters[section]
        return cell
    }
    
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40.0
   }
   
   //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   //    return
   //}
   //
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("FilterOptionViewCell", forIndexPath: indexPath) as FilterOptionViewCell
    
        cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        cell.contentView.layer.cornerRadius = 4.0
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //cell.filterViewDelegate = delegate
        //cell = setInitialSwitchValue(cell, section: indexPath.section, row: indexPath.row)

        cell.optionLabel.text = "test"
    
        return cell
   }
   //
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
        return 1
    case 1:
        return 1
    case 2:
        return 1
    case 3:
        return 4
    default:
        return 0
    }
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return filters.count
   }
    
   // Private functions
    
   private func customizeNavigationBar() {
       let yelpRed = UIColor(hexString: "#AF0606")
    
       self.navigationController!.navigationBar.configureFlatNavigationBarWithColor(yelpRed)
       
       self.cancelButton.configureFlatButtonWithColor(UIColor.alizarinColor(), highlightedColor: UIColor.carrotColor(), cornerRadius: 5.0)
       self.cancelButton.tintColor = UIColor.whiteColor()
    
       self.searchButton.configureFlatButtonWithColor(UIColor.alizarinColor(), highlightedColor: UIColor.carrotColor(), cornerRadius: 5.0)
       self.searchButton.tintColor = UIColor.whiteColor()
   }
}
