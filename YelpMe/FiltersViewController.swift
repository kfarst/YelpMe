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
    func showDealsSelected(_ selected: Bool)
    func radiusSelected(_ distanceInMeters: Int, rowSelected: Int)
    func sortBySelected(_ sortBy: Int, rowSelected: Int)
    func categorySelected(_ category: String, selected: Bool)
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
    
    @IBAction func dismissFilterView(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func searchWithFilter(_ sender: AnyObject) {
        self.delegate.searchWithFilterClicked()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        let yelpRed = UIColor(hexString: "#AF0606")
        
        self.navigationController!.navigationBar.configureFlatNavigationBar(with: yelpRed)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        self.cancelButton.configureFlatButton(with: UIColor.pomegranate(), highlightedColor: UIColor.alizarin(), cornerRadius: 5.0)
        self.cancelButton.tintColor = UIColor.white
        
        self.searchButton.configureFlatButton(with: UIColor.pomegranate(), highlightedColor: UIColor.alizarin(), cornerRadius: 5.0)
        self.searchButton.tintColor = UIColor.white
        
        if UIDevice.current.orientation.isLandscape || sectionExpanded[3]! {
            self.filterTableView.isScrollEnabled = true
        } else {
            self.filterTableView.isScrollEnabled = false
        }
        
        self.filterTableView.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        
        mapSelectedCategoriesToArrayIndexes()
        
        self.filterTableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape || sectionExpanded[3]! {
            self.filterTableView.isScrollEnabled = true
        } else {
            self.filterTableView.isScrollEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        
        header.backgroundColor = UIColor.white
        
        label.text = Filters.values[section].rawValue
        label.font = UIFont(name: "helvetica neue", size: 14)
        
        header.addSubview(label)
        
        return header
    }
    
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
   }
    
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 00.1
   }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let section = indexPath.section
    
       if section == 3 && indexPath.row == 3 && !sectionExpanded[section]! {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllViewCell") as! SeeAllViewCell
           cell.contentView.layer.borderColor = UIColor.black.cgColor
           cell.contentView.layer.borderWidth = 0.5
           cell.contentView.layer.borderColor = UIColor.gray.cgColor
           cell.contentView.layer.cornerRadius = 4.0
           cell.selectionStyle = UITableViewCellSelectionStyle.none
           return cell
       } else if section == 0 || section == 3 {
           var cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionViewCell") as! FilterOptionViewCell
           cell.section = indexPath.section
           cell.row = indexPath.row
           cell.contentView.layer.borderColor = UIColor.black.cgColor
           cell.contentView.layer.borderWidth = 0.5
           cell.contentView.layer.borderColor = UIColor.gray.cgColor
           cell.contentView.layer.cornerRadius = 4.0
           cell.selectionStyle = UITableViewCellSelectionStyle.none
           cell.delegate = delegate
           cell.optionSwitch.isOn = false
           cell = flipSwitchToCorrectValue(cell, section: indexPath.section, row: indexPath.row)
           return cell
           
       } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownOptionViewCell") as! DropdownOptionViewCell
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
           
           cell.contentView.layer.borderColor = UIColor.gray.cgColor
           cell.contentView.layer.cornerRadius = 4.0
           
           cell.selectionStyle = UITableViewCellSelectionStyle.none
           cell.delegate = delegate
           return cell
       }
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        filterTableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        
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
            filterTableView.isScrollEnabled = true
            
            mapSelectedCategoriesToArrayIndexes()
        }
        
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
   
   func numberOfSections(in tableView: UITableView) -> Int {
       return Filters.values.count
   }
    
   func dismissFilterView() {
       self.navigationController?.popToRootViewController(animated: true)
   }
   
   fileprivate func flipSwitchToCorrectValue(_ cell: FilterOptionViewCell, section: Int, row: Int) -> FilterOptionViewCell {
       if section == 0 {
           if (showDealsSelected) {
               cell.optionSwitch.setOn(true, animated: false)
           }
       } else if section == 3 {
            print("Categories selectd: \(categoriesSelected)")
            print("Row is: \(row)")
           if categoryRowsSelected.contains(row) {
               cell.optionSwitch.setOn(true, animated: false)
           }
       }
    
       return cell
   }
    
    fileprivate func mapSelectedCategoriesToArrayIndexes() {
        for cat in categoriesSelected {
            let index: Int! = category.allValuesForKey("code").index(of: cat)
            
            if !categoryRowsSelected.contains(index!) {
                categoryRowsSelected.append(index)
            }
        }
    }
}
