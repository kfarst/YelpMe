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
        buildListing()
    }
    
    // Private functions
    
    private func buildListing() {
        var location = listing["location"] as NSDictionary
        
        nameLabel.text = listing["name"] as? String
        addressLabel.text = location["display_address"] as [String]
        categoriesLabel.text = listing["categories"] as [String]
        distanceLabel.text = "1.4 mi"
        
        var reviewCount = listing["review_count"] as? Int
        reviewsLabel.text = "\(reviewCount) Reviews"
        
        var imageURL = listing["image_url"] as? String
        
        if let overviewImageURL = imageURL {
            overviewImage.setImageWithURL(NSURL(string: overviewImageURL))
        }
        
        var ratingsImageURL = listing["rating_img_url"] as? String
        
        ratingImage.setImageWithURL(NSURL(string: ratingsImageURL!))
    }
}
