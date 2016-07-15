//
//  BusinessCell.swift
//  Yelp
//
//  Created by Duy Nguyen on 12/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var business : Business! {
        
        didSet {
            
            if business.imageURL != nil {
                self.restaurantImage.alpha = 0
                UIView.animateWithDuration(0.3, animations: {
                    self.restaurantImage.alpha = 1
                    self.restaurantImage.setImageWithURL(self.business.imageURL!)
                })
            }
            
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewImage.setImageWithURL(business.ratingImageURL!)
            reviewLabel.text = (business.reviewCount?.stringValue)! + " reviews"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            
        }
    }
    
}
