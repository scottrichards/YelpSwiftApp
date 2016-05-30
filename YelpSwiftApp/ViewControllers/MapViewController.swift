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
    var locationName : String?  // the name of the place e.g. "Sweetwater"
    
    
    
    override func viewDidLoad() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        super.viewDidLoad()
        if let title = locationName {
            self.navigationItem.title = title
        }
        if let _ = location {
            goToLocation(location!)
        }

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
