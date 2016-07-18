//
//  EateryPin.swift
//  Yelp
//
//  Created by Duy Nguyen on 18/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import MapKit

class EateryPin: NSObject, MKAnnotation {
    
    let eatery: Business!
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(eatery: Business, title: String?, subtitle: String) {
        self.eatery = eatery
        self.coordinate = CLLocationCoordinate2D(latitude: Double(eatery.latitude), longitude: Double(eatery.longitude))
        self.title = title
        self.subtitle = subtitle
    }
}