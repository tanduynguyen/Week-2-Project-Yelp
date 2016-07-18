//
//  YelpSearchSettings.swift
//  Yelp
//
//  Created by Duy Nguyen on 16/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation


// Model class that represents the user's search settings
class YelpSearchSettings: NSObject, NSCoding {
    var searchString = ""
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    var switchStates = [Int: Bool]()
    var distance: Double = 0
    var distanceText = "Auto"
    static let storeSearchSettingsKey = "storeSearchSettingsKey"

    
    static let modes = [YelpSortMode.BestMatched, YelpSortMode.Distance, YelpSortMode.HighestRated]
    static let distances = [[0: "Auto"], [0.3: "0.3 miles"], [1: "1 mile"], [5: "5 mile"], [20: "20 miles"]]

    static let sharedInstance = YelpSearchSettings(coder: NSCoder())
    
    override init() {
        
        super.init()
    }
    
    @objc required convenience init(coder aDecoder: NSCoder) {
        self.init()

        searchString = aDecoder.decodeObjectForKey("searchString") as! String
        categories = aDecoder.decodeObjectForKey("categories") as? [String]
        deals = aDecoder.decodeObjectForKey("deals") as? Bool
        switchStates = aDecoder.decodeObjectForKey("switchStates") as! [Int: Bool]
        distance = aDecoder.decodeObjectForKey("distance") as! Double
        distanceText = aDecoder.decodeObjectForKey("distanceText") as! String
        if let value = aDecoder.decodeObjectForKey("sort") {
            sort = YelpSortMode(rawValue: value as! Int)
        }
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(searchString, forKey: "searchString")
        aCoder.encodeObject(sort?.rawValue, forKey: "sort")
        aCoder.encodeObject(categories, forKey: "categories")
        aCoder.encodeObject(deals, forKey: "deals")
        aCoder.encodeObject(switchStates, forKey: "switchStates")
        aCoder.encodeObject(distance, forKey: "distance")
        aCoder.encodeObject(distanceText, forKey: "distanceText")
    }
    
    static func loadSearchSettings() -> YelpSearchSettings {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var object = YelpSearchSettings()
        if let savedPeople = defaults.objectForKey(YelpSearchSettings.storeSearchSettingsKey) as? NSData {
            object = NSKeyedUnarchiver.unarchiveObjectWithData(savedPeople) as! YelpSearchSettings
        }
        return object
    }
    
    static func saveSearchSettings(data: YelpSearchSettings) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(data)
        defaults.setObject(savedData, forKey: YelpSearchSettings.storeSearchSettingsKey)
        defaults.synchronize()
    }

}
