//
//  FiltersViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate
{
    func showDealsSelected(selected: Bool)
    func radiusSelected(distanceInMeters: Int, rowSelected: Int)
    func sortBySelected(sortBy: Int, rowSelected: Int)
    func categorySelected(category: String, selected: Bool)
    func searchWithFilterClicked()
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var showDealsSelected = false
    var radiusSelected = 0
    var sortBySelected = 0
    
    var categoriesSelected: [String] = []
    var categoryRowsSelected: [Int] = []
    var category: Category = Category()
    
    var radiusValues = [0, 482, 1609, 8046, 32186]
    var sortByValues = [0, 1, 2]
    
    weak var delegate: FiltersViewControllerDelegate!
    
    var sectionExpanded = [1: false, 2: false, 3: false]

    enum Filters: String {
       case Deals = ""
       case Radius = "Distance"
       case Sort = "Sort By"
       case Category = "Category"
        
       static let values = [Deals, Radius, Sort, Category]
    }

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBAction func dismissFilterView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func searchWithFilter(sender: AnyObject) {
        self.delegate.searchWithFilterClicked()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        let yelpRed = UIColor(hexString: "#AF0606")
        
        self.navigationController!.navigationBar.configureFlatNavigationBarWithColor(yelpRed)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.cancelButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
        self.cancelButton.tintColor = UIColor.whiteColor()
        
        self.searchButton.configureFlatButtonWithColor(UIColor.pomegranateColor(), highlightedColor: UIColor.alizarinColor(), cornerRadius: 5.0)
        self.searchButton.tintColor = UIColor.whiteColor()
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue || sectionExpanded[3]! {
            self.filterTableView.scrollEnabled = true
        } else {
            self.filterTableView.scrollEnabled = false
        }
        
        self.filterTableView.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        mapSelectedCategoriesToArrayIndexes()
        
        self.filterTableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue || sectionExpanded[3]! {
            self.filterTableView.scrollEnabled = true
        } else {
            self.filterTableView.scrollEnabled = false
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("OptionSectionHeaderViewCell") as OptionSectionHeaderViewCell
        
        cell.sectionHeaderLabel.text = Filters.values[section].rawValue
        return cell
    }
    
   func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       if section == 0 {
           return 10.0
       } else {
          return 40.0
       }
   }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var section = indexPath.section
    
       if section == 3 && indexPath.row == 3 && !sectionExpanded[section]! {
           var cell = tableView.dequeueReusableCellWithIdentifier("SeeAllViewCell") as SeeAllViewCell
           cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
           cell.contentView.layer.borderWidth = 0.5
           cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
           cell.contentView.layer.cornerRadius = 4.0
           cell.selectionStyle = UITableViewCellSelectionStyle.None
           return cell
       } else if section == 0 || section == 3 {
           var cell = tableView.dequeueReusableCellWithIdentifier("FilterOptionViewCell") as FilterOptionViewCell
           println("Hello I am at row \(indexPath.row) and section \(indexPath.section)")
           cell.section = indexPath.section
           cell.row = indexPath.row
           cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
           cell.contentView.layer.borderWidth = 0.5
           cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
           cell.contentView.layer.cornerRadius = 4.0
           cell.selectionStyle = UITableViewCellSelectionStyle.None
           cell.delegate = delegate
           cell = flipSwitchToCorrectValue(cell, section: indexPath.section, row: indexPath.row)
           return cell
           
       } else {
           var cell = tableView.dequeueReusableCellWithIdentifier("DropdownOptionViewCell") as DropdownOptionViewCell
           println("DistanceAndSortCell Hello I am at row \(indexPath.row) and section \(indexPath.section)")
           cell.section = indexPath.section
           if (!sectionExpanded[section]!) {
               if (section == 1) {
                   cell.row = radiusSelected
               } else if section == 2 {
                   cell.row = sortBySelected
               }
           } else {
               cell.row = indexPath.row
           }
           cell.sortByRowSelected = self.sortBySelected
           cell.distanceRowSelected = self.radiusSelected
           cell.sectionExpanded = sectionExpanded[section]!
           cell.contentView.layer.borderWidth = 0.5
           
           cell.contentView.layer.borderColor = UIColor.grayColor().CGColor
           cell.contentView.layer.cornerRadius = 4.0
           
           cell.selectionStyle = UITableViewCellSelectionStyle.None
           cell.delegate = delegate
           return cell
       }
   }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        filterTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var section = indexPath.section
        
        if section == 1 || section == 2 {
            if sectionExpanded[section]! {
                if section == 1 {
                    radiusSelected = indexPath.row
                    self.delegate.radiusSelected(radiusValues[indexPath.row], rowSelected: indexPath.row)
                } else {
                    sortBySelected = indexPath.row
                    self.delegate.sortBySelected(sortByValues[indexPath.row], rowSelected: indexPath.row)
                }
                sectionExpanded[section] = false
            } else {
                sectionExpanded[section] = true
            }
        } else if section == 3 && indexPath.row == 3 && !sectionExpanded[section]! {
            sectionExpanded[section] = true
            filterTableView.scrollEnabled = true
            
            mapSelectedCategoriesToArrayIndexes()
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if sectionExpanded[section]! {
                return 5
            } else {
                return 1
            }
        case 2:
            if sectionExpanded[section]! {
                return 3
            } else {
                return 1
            }
        case 3:
            if sectionExpanded[section]! {
                return category.list.count
            } else {
                return 4
            }
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
   
   private func flipSwitchToCorrectValue(cell: FilterOptionViewCell, section: Int, row: Int) -> FilterOptionViewCell {
       if section == 0 {
           if (showDealsSelected) {
               cell.optionSwitch.setOn(true, animated: false)
           }
       } else if section == 3 {
           var isCategoryRowSelected = find(categoryRowsSelected, row)
           if let isSelected = isCategoryRowSelected {
               cell.optionSwitch.setOn(true, animated: false)
           }
       }
    
       return cell
   }
    
    private func mapSelectedCategoriesToArrayIndexes() {
        for cat in categoriesSelected {
            categoryRowsSelected.append(find(category.allValuesForKey("code"), cat)!)
        }
    }
}
