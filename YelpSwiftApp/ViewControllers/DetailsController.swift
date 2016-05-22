//
//  DetailsController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/21/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    @IBOutlet var businessName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var ratingImage: UIImageView!
    @IBOutlet var reviewCount: UILabel!
    @IBOutlet var priceLevel: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var address: UILabel!
    var business : YelpBusiness?
    
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
    }
}
