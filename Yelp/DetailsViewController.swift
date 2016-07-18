//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Duy Nguyen on 18/7/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var business : Business!
    var eateryLocation: CLLocation!
    var eateryPin: EateryPin!
    let regionRadius: CLLocationDistance = 700
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = business.name
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        eateryLocation = CLLocation(
            latitude: Double(business.latitude),
            longitude: Double(business.longitude)
        )
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(eateryLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0);
        
        eateryPin = EateryPin(
            eatery: business,
            title: business.name,
            subtitle: business.address!
        )
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(eateryPin)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.selectAnnotation(eateryPin, animated: true)
    }

}