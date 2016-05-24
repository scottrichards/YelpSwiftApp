//
//  MapCell.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/23/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {
    @IBOutlet var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
