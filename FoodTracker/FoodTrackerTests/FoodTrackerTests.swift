//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Metacube on 02/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    // MARK: FoodTracker Tests
    func testMealInitialization() {
        // Success Case.
        let potentialItem = Meal(name: "Newest Meal", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure Cases.
        let noName = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let negativeRating = Meal(name: "Negative Rating Meal", photo: nil, rating: -1)
        XCTAssertNil(negativeRating, "Negative Rating is invalid")
    }
    
}
