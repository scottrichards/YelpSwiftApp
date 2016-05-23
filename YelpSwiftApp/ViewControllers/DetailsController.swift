//
//  DetailsController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/21/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController {
    @IBOutlet var businessName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var ratingImage: UIImageView!
    @IBOutlet var reviewCount: UILabel!
    @IBOutlet var priceLevel: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var mapView: MKMapView!
    var business : YelpSwiftBusiness?
    
    @IBAction func onBackToSearch(sender: AnyObject) {
          self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        if business == nil {
            return
        }
        businessName.text = business?.name
        distance.text = business?.distance
        ratingImage.setImageWithURL((business?.ratingImageUrl!)!)
        address.text = business?.address
        category.text = business?.categories
        let reviewCount = (business?.reviewCount)!
        self.reviewCount.text =  NSString(format: "%ld Reviews",reviewCount.integerValue) as String
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)
    }
    
    // center the map around the specified location
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
}
