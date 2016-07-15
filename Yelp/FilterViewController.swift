//
//  FilterViewController.swift
//  Yelp
//
//  Created by Duy Nguyen on 15/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    
    optional func filtersViewController(filterVC: FilterViewController, didUpdateFilter filter: [String])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var switchStates = [Int: Bool]()
    weak var delegate : FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
    }
    
    @IBAction func onSearch(sender: AnyObject) {

        var filters = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                filters.append(categories[row]["code"]!)
            }
        }
        
        if filters.count > 0 {
            delegate?.filtersViewController?(self, didUpdateFilter: filters)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension FilterViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(SwitchCell)) as! SwitchCell
        cell.nameLabel.text = categories[indexPath.row]["name"]
        cell.switchButton.on = switchStates[indexPath.row] ?? false
        cell.delegate = self
        
        return cell
    }
}


extension FilterViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPathForCell(switchCell)
        switchStates[indexPath!.row] = value
    }
}