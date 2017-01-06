//
//  UnitTestTestingTests.swift
//  UnitTestTestingTests
//
//  Created by Arpit Pittie on 06/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import XCTest
@testable import UnitTestTesting

class UnitTestTestingTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    func testAssition() {
        XCTAssertEqual(viewController.addition(firstNumber: 2290.45, secondNumber: 125.07), 2415.52)
        XCTAssertNotEqual(viewController.addition(firstNumber: 65874.3215, secondNumber: 741.00), 236)
    }
    
    func testSubtration() {
        XCTAssertEqual(viewController.subtraction(firstNumber: 659.54, secondNumber: 879.6541), -220.1141)
        XCTAssertNotEqual(viewController.subtraction(firstNumber: 987.32, secondNumber: 95.14), -632.87)
        XCTAssertEqual(viewController.subtraction(firstNumber: 45652.312, secondNumber: 23659.1), 21993.212)
    }
    
    func testMultiplication() {
        XCTAssertEqual(viewController.multiplication(firstNumber: 25.02, secondNumber: 65.41), 1636.5582)
    }
    
    func testDivision() {
        XCTAssertEqualWithAccuracy(viewController.division(divident: 98741.31, divisor: 52.962), 1864.38031, accuracy: 0.1)
        XCTAssertEqual(viewController.division(divident: 236.2, divisor: 0), 0)
    }
    
    func testRemainder() {
        XCTAssertNotEqual(viewController.remainder(divident: 7413, divisor: 98), 36)
    }
    
    func testRaiseToPower() {
        XCTAssertEqual(viewController.raiseToPower(base: 2, power: 10), 1024)
    }
    
    func testGreaterThan() {
        XCTAssertTrue(viewController.greaterThan(firstNumber: 1, secondNumber: 0))
        XCTAssertFalse(viewController.greaterThan(firstNumber: 87402.01, secondNumber: 87402.02))
    }
    
    func testLessThan() {
        XCTAssertTrue(viewController.lessThan(firstNumber: 45.87, secondNumber: 45.998), "The second input number is larger")
        XCTAssertFalse(viewController.lessThan(firstNumber: 6985, secondNumber: 789.087))
    }
    
    func testSimpleInterest() {
        XCTAssertEqualWithAccuracy(viewController.simpleInterest(principle: 32000.50, time: 6, rateOfInterest: 8.54), 16400, accuracy: 10)
    }
    
}
