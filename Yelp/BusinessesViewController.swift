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

    var businesses: [Business]! = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navController = segue.destinationViewController as! UINavigationController
        let filterVC = navController.topViewController as! FilterViewController
        
        filterVC.delegate = self
    }
    

}

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let business = businesses[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(String(BusinessCell)) as! BusinessCell
        cell.business = business
        
        return cell
    }
}

extension BusinessesViewController: FilterViewControllerDelegate {
    
    func filtersViewController(filterVC: FilterViewController, didUpdateFilter filter: [String]) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm("Thai", sort: nil, categories: filter, deals: nil) { (businesses, error) in
            
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
}
