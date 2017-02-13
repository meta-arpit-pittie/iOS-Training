//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Metacube on 05/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
