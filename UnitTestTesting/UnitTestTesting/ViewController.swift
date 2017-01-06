//
//  ViewController.swift
//  UnitTestTesting
//
//  Created by Arpit Pittie on 06/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func addition(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber + secondNumber
    }
    
    func subtraction(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber - secondNumber
    }
    
    func multiplication(firstNumber: Double, secondNumber: Double) -> Double {
        return firstNumber * secondNumber
    }
    
    func division(divident: Double, divisor: Double) -> Double {
        if divisor == 0 {
            return 0
        }
        return divident / divisor
    }
    
    func raiseToPower(base: Double, power: Int) -> Double {
        var result: Double = 1
        for _ in 1...power {
            result *= base
        }
        return result
    }
    
    func remainder(divident: Int, divisor: Int) -> Int {
        return divident % divisor
    }
    
    func greaterThan(firstNumber: Double, secondNumber: Double) -> Bool {
        if firstNumber > secondNumber {
            return true
        } else {
            return false
        }
    }
    
    func lessThan(firstNumber: Double, secondNumber: Double) -> Bool {
        if firstNumber < secondNumber {
            return true
        } else {
            return false
        }
    }
    
    func simpleInterest(principle: Double, time: Double, rateOfInterest: Double) -> Double {
        let si = division(divident:
            multiplication(firstNumber:
                multiplication(firstNumber: principle, secondNumber: time), secondNumber: rateOfInterest), divisor: 100)
        return si
    }

}

