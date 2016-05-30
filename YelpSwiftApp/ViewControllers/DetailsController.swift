//
//  DetailsController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/21/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var businessName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var ratingImage: UIImageView!
    @IBOutlet var reviewCount: UILabel!
    @IBOutlet var priceLevel: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    
    var business : YelpBusiness?
    
    enum TableRowType : Int {
        case map = 0
        case phone = 1
    }
    
    @IBAction func onBackToSearch(sender: AnyObject) {
          self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
  //      navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .Plain, target: nil, action: nil)
        if business == nil {
            return
        }
        businessName.text = business?.name
        distance.text = business?.distance
        ratingImage.setImageWithURL((business?.ratingImageUrl!)!)
        category.text = business?.categories
        let reviewCount = (business?.reviewCount)!
        self.reviewCount.text =  NSString(format: "%ld Reviews",reviewCount.integerValue) as String
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        if let centerLocation = business?.location {
            goToLocation(centerLocation)
        }

    }
    
    // center the map around the specified location
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.row {
        case TableRowType.map.rawValue:
            let identifier = "MapCell"
            if let dequeuedCell : MapCell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MapCell
            {
                dequeuedCell.addressLabel.text = business?.address
                cell = dequeuedCell
            }
        default:
            let identifier = "PhoneCell"
            if let dequeuedCell : PhoneCell = tableView.dequeueReusableCellWithIdentifier(identifier) as? PhoneCell {
                dequeuedCell.phoneLabel.text = business?.phoneNumber
                cell = dequeuedCell
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case TableRowType.map.rawValue:
            if let centerLocation = business?.location {
                if let mapView : MapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewId") as? MapViewController
                {
                    mapView.location = centerLocation
                    mapView.locationName = business?.name
                    self.navigationController?.pushViewController(mapView, animated: true)
                }
            }
        default:
            if let phoneNumber = business?.phoneNumber {
                dialPhone(phoneNumber)
            }
        }

    }
    
    func dialPhone(phone: String) {
        if let url = NSURL(string: "tel://\(phone)") {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    
}
