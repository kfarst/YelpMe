//
//  DropdownOptionViewCell.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/13/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class DropdownOptionViewCell: UITableViewCell {
    
    var section: Int = -1
    var row: Int = -1
    var sectionExpanded = false
    var isRowSelected = false
    
    var sortByRowSelected = 0
    var distanceRowSelected = 0
    
    var delegate: FiltersViewControllerDelegate!

    var distanceCategories = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    var distanceCategoriesValue = [0, 482, 1609, 8046, 32186]
    var sortByCategories = ["Best Match", "Distance", "Rating"]
    var sortByCategoriesValue = [0, 1, 2]
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var uncheckedImage: UIImageView!
    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var downArrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
        
        if (section == 1) {
            self.optionLabel.text = distanceCategories[row]
            if (row == distanceRowSelected) {
                isRowSelected = true
            } else {
                isRowSelected = false
            }
        }
        if (section == 2) {
            self.optionLabel.text = sortByCategories[row]
            if (row == sortByRowSelected) {
                isRowSelected = true
            } else {
                isRowSelected = false
            }
        }
        if (sectionExpanded) {
            downArrowImage.isHidden = true
            if (isRowSelected) {
                checkedImage.isHidden = false
                uncheckedImage.isHidden = true
            } else {
                checkedImage.isHidden = true
                uncheckedImage.isHidden = false
            }
        } else {
            checkedImage.isHidden = true
            uncheckedImage.isHidden = true
            downArrowImage.isHidden = false
        }
    }
}
