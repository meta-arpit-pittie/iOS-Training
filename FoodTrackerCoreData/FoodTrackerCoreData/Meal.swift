//
//  Meal.swift
//  FoodTracker
//
//  Created by Metacube on 05/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

class Meal: NSObject {
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
}
