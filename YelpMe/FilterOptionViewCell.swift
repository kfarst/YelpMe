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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let yelpRed = UIColor(hexString: "#AF0606")
        optionSwitch.onTintColor = yelpRed
    }
}
