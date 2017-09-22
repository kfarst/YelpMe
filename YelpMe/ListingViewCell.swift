//
//  ListingViewCell.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/10/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import UIKit

class ListingViewCell: UITableViewCell {

    @IBOutlet weak var overviewImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var listing: NSDictionary = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
        buildListing()
    }
    
    // Private functions
    
    fileprivate func buildListing() {
        let location = listing["location"] as! NSDictionary
        
        nameLabel.text = listing["name"] as? String
        addressLabel.text = self.getCommaSeparatedString(location["display_address"] as! [String])
        
        if let categories = listing["categories"] as? [String] {
            categoriesLabel.text = self.getCommaSeparatedString(categories)
        }
        
        distanceLabel.text = "1.4 mi"
        
        let reviewCount = listing["review_count"] as? Int
        
        if let reviews = reviewCount {
            reviewsLabel.text = "\(reviews) Reviews"
        }
        
        let imageURL = listing["image_url"] as? String
        
        if let overviewImageURL = imageURL {
            overviewImage.setImageWith(URL(string: overviewImageURL))
        }
        
        let ratingsImageURL = listing["rating_img_url"] as? String
        
        let categories = listing["categories"] as? [[String]]
        
        var categoryLabelString = ""
        
        _ = 0
        
        if let categories = categories {
            for (idx, category) in categories.enumerated() {
                if (idx < categories.count - 1) {
                    categoryLabelString += "\(category[0]), "
                } else {
                    categoryLabelString += "\(category[0])"
                }
            }
            
            categoriesLabel.text = categoryLabelString
        } else {
            categoriesLabel.isHidden = true
        }
        
        ratingImage.setImageWith(URL(string: ratingsImageURL!))
    }
    
    
    fileprivate func getCommaSeparatedString(_ arr: [String]) -> String {
        var str : String = ""
        for (idx, item) in arr.enumerated() {
            str += "\(item)"
            if idx < arr.count - 1 {
                str += ", "
            }
        }
        return str
    }
}
