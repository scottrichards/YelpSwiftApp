//
//  MapViewController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/23/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var location : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Location"
        if let _ = location {
            goToLocation(location!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // center the map around the specified location
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }


}
