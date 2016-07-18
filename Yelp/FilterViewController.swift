//
//  FilterViewController.swift
//  Yelp
//
//  Created by Duy Nguyen on 15/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    
    optional func filtersViewController(filterVC: FilterViewController, didUpdateFilter searchSettings: YelpSearchSettings)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    weak var delegate : FilterViewControllerDelegate?
    var searchSettings = YelpSearchSettings.loadSearchSettings()
    var showAllCategories = false
    var showAllDistances = false
    var showAllSorts = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        YelpSearchSettings.saveSearchSettings(searchSettings)
    }
    
    @IBAction func onSearch(sender: AnyObject) {

        var filters = [String]()
        
        for (row, isSelected) in searchSettings.switchStates {
            if isSelected {
                filters.append(categories[row]["code"]!)
            }
        }
        
        searchSettings.categories = filters;
        delegate?.filtersViewController?(self, didUpdateFilter: searchSettings)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetAllFilters(sender: AnyObject) {
        
        self.searchSettings = YelpSearchSettings()
        showAllCategories = false
        showAllSorts = false
        
        self.tableView.reloadData()
    }
}


extension FilterViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            if showAllDistances {
                return YelpSearchSettings.distances.count
            }
            return 1
        case 2:
            if showAllSorts {
                return 4
            }
            return 1
        case 3:
            if !showAllCategories {
                return 4
            }
            return categories.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return ""
        case 1: return "Distance"
        case 2: return "Sort by"
        case 3: return "Category"
        default: return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0, 3:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(SwitchCell)) as! SwitchCell
            cell.delegate = self
            
            if indexPath.section == 0 {
                cell.nameLabel.text = "Offering a Deal"
                cell.switchButton.on = searchSettings.deals ?? false
            } else {
                let index = indexPath.row
                if !showAllCategories && index == 3 {
                    return tableView.dequeueReusableCellWithIdentifier("SeeAllCell")!
                }
                cell.nameLabel.text = categories[index]["name"]
                cell.switchButton.on = searchSettings.switchStates[index] ?? false
            }
            
            return cell
            
        case 1, 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(SelectCell)) as! SelectCell
            var hasChecked: Bool?
            var name = "Auto"

            if indexPath.section == 2 {
                
                let selectedMode = searchSettings.sort
                if showAllSorts {
                    
                    hasChecked = false
                    if (indexPath.row > 0) {
                        let mode = YelpSearchSettings.modes[indexPath.row - 1] as YelpSortMode
                        name = mode.getText()
                        hasChecked = selectedMode == mode
                    } else if selectedMode == nil {
                        hasChecked = true
                    }
                    
                } else if selectedMode != nil {
                    name = selectedMode!.getText()
                }

            } else {
                
                if showAllDistances {
                    
                    let dict = YelpSearchSettings.distances[indexPath.row] as Dictionary
                    let key = dict.keys.first
                    hasChecked = key == searchSettings.distance
                    name = dict.values.first!
                } else {
                    name = searchSettings.distanceText
                }

                cell.nameLabel.text = "Auto"
            }
            
            cell.nameLabel.text = name
            cell.hasChecked = hasChecked
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 1:
            
            if showAllDistances {
                let dict = YelpSearchSettings.distances[indexPath.row] as Dictionary
                searchSettings.distance = dict.keys.first!
                searchSettings.distanceText = dict.values.first!
            }
            
            showAllDistances = !showAllDistances

            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 2:
            
            if showAllSorts {
                if indexPath.row == 0 {
                    searchSettings.sort = nil
                } else {
                    searchSettings.sort = YelpSearchSettings.modes[indexPath.row - 1]
                }
            }
            showAllSorts = !showAllSorts

            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            break
        case 3:
            
            if indexPath.row == 3 {
                showAllCategories = !showAllCategories
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            break
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension FilterViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPathForCell(switchCell)

        if indexPath!.section == 0 {
            searchSettings.deals = value
        } else {
            searchSettings.switchStates[indexPath!.row] = value
        }
    }
}