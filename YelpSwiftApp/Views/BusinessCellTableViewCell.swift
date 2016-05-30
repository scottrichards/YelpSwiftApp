//
//  BusinessCellTableViewCell.swift
//  Yelp
//
//  Created by Scott Richards on 5/14/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit



class BusinessCellTableViewCell: UITableViewCell {
    @IBOutlet var thumbImageView: UIImageView!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingImage: UIImageView!
    @IBOutlet var reviewCount: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    var business : YelpBusiness? {
        didSet {
            if let imageUrl = self.business?.imageUrl {
                self.thumbImageView.setImageWithURL(imageUrl)
            } else {
                self.thumbImageView.image = nil
            }
            self.nameLabel.text = business?.name
            if let ratingImageUrl = self.business?.ratingImageUrl {
                self.ratingImage.setImageWithURL(ratingImageUrl)
            }
            if let reviewCount = business?.reviewCount {
                self.reviewCount.text = NSString(format: "%ld Reviews",reviewCount.integerValue) as String
            }
            self.address.text = business?.address
            self.typeLabel.text = business?.categories
            self.distanceLabel.text = business?.distance
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
  //      self.thumbImageView.setThu
        // Configure the view for the selected state
    }
    
}
