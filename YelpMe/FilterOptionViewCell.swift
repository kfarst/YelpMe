//
//  FilterOptionViewCell.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/11/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class FilterOptionViewCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    
    var section: Int! = -1
    var row: Int! = -1
    
    var category: Category! = Category()
    var delegate: FiltersViewControllerDelegate!
    
    var dealCategory = ["Offering a Deal"]
    var distanceCategories = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distanceCategoriesValue = [0, 482, 1609, 8046, 32186]
    var sortByCategories = ["Best Match": 0, "Distance": 1, "Rating": 2]
    
    var filterOptionViewDelegate: FiltersViewControllerDelegate!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let yelpRed = UIColor(hexString: "#AF0606")
        
        optionSwitch.onTintColor = yelpRed
        
        self.optionLabel.sizeToFit()
        
        switch section {
        case 0:
            self.optionLabel.text = dealCategory[row]
        case 3:
            self.optionLabel.text = category.list[row]["name"]
        default:
            self
        }
        
        self.backgroundColor = UIColor.whiteColor()
        
        optionSwitch.addTarget(self, action: Selector("switchValueFlipped:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func switchValueFlipped(sender: UISwitch) {
        println("switchControlValueChanged \(row) and section \(section)")
        var selected: Bool = sender.on
        
        if section == 0 {
            delegate.showDealsSelected(selected)
        } else if section == 3 {
            delegate.categorySelected(category.list[row]["code"]!, selected: selected)
        }
    }

}
