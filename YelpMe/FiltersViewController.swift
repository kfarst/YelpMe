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
    func showDealsSelected(selected: Bool)
    func radiusSelected(distanceInMeters: Int, rowSelected: Int)
    func sortBySelected(sortBy: Int, rowSelected: Int)
    func categorySelected(category: String, selected: Bool)
    func searchWithFilterClicked()
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var distance = ["5 miles", "10 miles", "15 miles", "25 miles"]
    var sortBy = ["Best Matched", "Distance", "Highest Rated"]

    let delegate: FiltersViewControllerDelegate?

    enum Filters: String {
       case Deals = "Deals"
       case Radius = "Distance"
       case Category = "Category"
       case Sort = "Sort By"
        
       static let values = [Deals, Radius, Category, Sort]
    }

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        customizeNavigationBar()
        
        cancelButton.addTarget(self, action: "dismissFilterView")
        
        self.filterTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("OptionSectionHeaderViewCell") as OptionSectionHeaderViewCell
        
        cell.sectionHeaderLabel.text = Filters.values[section].rawValue
        return cell
    }
    
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40.0
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("FilterOptionViewCell", forIndexPath: indexPath) as FilterOptionViewCell
        
        cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
        cell.contentView.layer.cornerRadius = 4.0
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //cell.filterViewDelegate = delegate
        //cell = setInitialSwitchValue(cell, section: indexPath.section, row: indexPath.row)
    
        switch indexPath.section {
            case 0:
                cell.optionLabel.text = Filters.Deals.rawValue
            case 1:
                cell.optionLabel.text = sortBy[indexPath.row]
            case 2:
                cell.optionLabel.text = Category().list[indexPath.row]["name"]
            case 3:
                cell.optionLabel.text = sortBy[indexPath.row]
            default:
                cell.optionLabel.text = ""
            return
        }
    
        return cell
   }

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
       return Filters.values.count
   }
    
    func dismissFilterView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
   // Private functions
    
   private func customizeNavigationBar() {
       let yelpRed = UIColor(hexString: "#AF0606")
    
       self.navigationController!.navigationBar.configureFlatNavigationBarWithColor(yelpRed)
       self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
       
       self.cancelButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
       self.cancelButton.tintColor = UIColor.whiteColor()
    
       self.searchButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
       self.searchButton.tintColor = UIColor.whiteColor()
   }
}
