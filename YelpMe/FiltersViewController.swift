//
//  FiltersViewController.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    let filters = ["Category", "Sort", "Radius", "Deals"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title: UILabel = UILabel()
        title.text = filters[section]
        return title
    }
    
   //func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
   //    return
   //}
   //
   //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   //    return
   //}
   //
   //func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   //    return
   //}
   //
   //func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //    return
   //}
   //
   //func numberOfSectionsInTableView(tableView: UITableView) -> Int {
   //    return filters.count
   //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
