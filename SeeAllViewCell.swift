//
//  SeeAllViewCell.swift
//  
//
//  Created by Kevin Farst on 2/13/15.
//
//

import UIKit

class SeeAllViewCell: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UIView!

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
    }

}
