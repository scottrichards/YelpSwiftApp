//
//  YelpSwiftBusiness.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/22/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class YelpSwiftBusiness: NSObject {
    var name : String?
    var address : String = ""
    var imageUrl : NSURL?
    var categories : String = ""
    var distance : String?
    var ratingImageUrl : NSURL?
    var reviewCount : NSNumber?
    var location : CLLocation?
    
    init (dict : NSDictionary) {
        super.init()
        name = dict["name"] as? String
        
        
        if let imageUrlString = dict["image_url"] as? String {
            imageUrl = NSURL(string: imageUrlString)
        }
        
        address = ""
        if let locationDictionary = dict["location"] {
            if let addressArray = locationDictionary["address"] as? NSArray {
                if let addressString = addressArray[0] as? String {
                    address += addressString
                }
            }
            
            if let neighborhoods = locationDictionary["neighborhoods"] as? NSArray {
                if (address.characters.count > 0) {
                    address += ", "
                }
                address += (neighborhoods[0] as? String)!
            }

            if let coordinate : NSDictionary = locationDictionary["coordinate"] as? NSDictionary {
                let latitude : Double = (coordinate["latitude"] as? Double)!
                let longitude : Double = (coordinate["longitude"] as? Double)!
                self.location = CLLocation(latitude: latitude, longitude: longitude)
            }
            
        }
        
        categories = ""
        if let categoriesArray : NSArray = dict["categories"]  as? NSArray {
            for x in 0 ..< categoriesArray.count {
                if let categoryStr : String = categoriesArray[x] as? String {
                    categories += categoryStr
                }
            }
        }

        if let distanceMeters :NSNumber = dict["distance"] as? NSNumber {
            let milesPerMeter : Double = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters.doubleValue)
        }
        
        if let ratingImageUrlString : String = dict["rating_img_url_large"] as? String {
            ratingImageUrl = NSURL(string: ratingImageUrlString)
        }
        
        reviewCount = dict["review_count"] as? NSNumber
    }

    class func businessesFromJsonArray(jsonArray : NSArray) -> NSArray {
        let result = NSMutableArray()
        for json in jsonArray  {
            if let jsonDictionary = json as? NSDictionary {
                let business = YelpSwiftBusiness(dict: jsonDictionary)
                result.addObject(business)
            }
        }
        return result
    }

}
