//
//  FiltersViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let filters = ["Category", "Sort", "Radius", "Deals"]

    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        self.filterTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = filterTableView.dequeueReusableCellWithIdentifier("OptionSectionHeaderViewCell") as OptionSectionHeaderViewCell
        cell.sectionHeaderLabel.text = filters[section]
        println("Calling section header")
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
        cell.optionLabel.text = "test"
        println("Calling option cell")
        return cell
   }
   //
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    println("Getting number of rows in section")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
