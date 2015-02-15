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
        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.whiteColor()
        buildListing()
    }
    
    // Private functions
    
    private func buildListing() {
        var location = listing["location"] as NSDictionary
        
        nameLabel.text = listing["name"] as? String
        addressLabel.text = self.getCommaSeparatedString(location["display_address"] as [String])
        
        if let categories = listing["categories"] as? [String] {
            categoriesLabel.text = self.getCommaSeparatedString(categories)
        }
        
        distanceLabel.text = "1.4 mi"
        
        var reviewCount = listing["review_count"] as? Int
        
        if let reviews = reviewCount {
            reviewsLabel.text = "\(reviews) Reviews"
        }
        
        var imageURL = listing["image_url"] as? String
        
        if let overviewImageURL = imageURL {
            overviewImage.setImageWithURL(NSURL(string: overviewImageURL))
        }
        
        var ratingsImageURL = listing["rating_img_url"] as? String
        
        ratingImage.setImageWithURL(NSURL(string: ratingsImageURL!))
    }
    
    
    private func getCommaSeparatedString(arr: [String]) -> String {
        var str : String = ""
        for (idx, item) in enumerate(arr) {
            str += "\(item)"
            if idx < arr.count - 1 {
                str += ","
            }
        }
        return str
    }
}
