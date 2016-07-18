//
//  SelectCell.swift
//  Yelp
//
//  Created by Duy Nguyen on 17/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    var hasChecked: Bool? {
        didSet {
            var imageName = "arrow-down"
            if hasChecked != nil {
                imageName = hasChecked == true ? "check_on" : "check_off"
            }
            checkImageView.image = UIImage(named: imageName)
        }
    }
}