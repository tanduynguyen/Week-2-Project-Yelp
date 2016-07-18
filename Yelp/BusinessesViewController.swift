//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    
    var businesses: [Business]! = []
    var searchSettings = YelpSearchSettings.loadSearchSettings()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search restaurant..."
        searchBar.text = searchSettings.searchString
        searchBar.backgroundColor = UIColor.clearColor()
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        doSearch()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        YelpSearchSettings.saveSearchSettings(searchSettings)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "filterSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let filterVC = navController.topViewController as! FilterViewController
            
            filterVC.delegate = self
            filterVC.searchSettings = self.searchSettings
        }
        
        
        if segue.identifier == "detailSegue" {
            let selectedCell = sender as! BusinessCell
            let vc = segue.destinationViewController as! DetailsViewController
            
            vc.business = selectedCell.business
        }

    }
    

}

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses.count == 0 {
            return 1
        }
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if businesses.count == 0 {
            
            return tableView.dequeueReusableCellWithIdentifier("NoResultCell")!
        }
        let business = businesses[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(String(BusinessCell)) as! BusinessCell
        cell.business = business
        
        return cell
    }
}

extension BusinessesViewController: FilterViewControllerDelegate {
    
    func filtersViewController(filterVC: FilterViewController, didUpdateFilter searchSettings: YelpSearchSettings) {
        
        self.searchSettings = searchSettings
        
        doSearch()
    }
}


// SearchBar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text!
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func doSearch() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm(searchSettings.searchString, sort: searchSettings.sort, categories: searchSettings.categories, deals: searchSettings.deals, distance: searchSettings.distance) { (businesses, error) in
            
            self.businesses = businesses
            self.tableView.reloadData()
            
            let scrollIndexPath: NSIndexPath = NSIndexPath(forRow:NSNotFound , inSection: 0)
            self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)

            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}

