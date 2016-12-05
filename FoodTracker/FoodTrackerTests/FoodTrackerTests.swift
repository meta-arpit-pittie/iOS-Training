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
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testMealInitialization() {
        // Success Case.
        let potentialItem = Meal(name: "Newest Meal", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure Cases.
        let noName = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName)
    }
    
}
