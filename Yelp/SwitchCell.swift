//
//  SwitchCell.swift
//  Yelp
//
//  Created by Duy Nguyen on 15/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: SwitchCellDelegate?

    @IBAction func onSwitchChanged(sender: AnyObject) {
        
        delegate?.switchCell?(self, didChangeValue: switchButton.on)
    }
    
}
