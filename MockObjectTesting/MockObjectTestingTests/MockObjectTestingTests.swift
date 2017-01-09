//
//  MockObjectTestingTests.swift
//  MockObjectTestingTests
//
//  Created by Arpit Pittie on 07/01/17.
//  Copyright © 2017 Metacube. All rights reserved.
//

import XCTest
import OCMock
@testable import MockObjectTesting

class MockObjectTestingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testOCMMockInSwift() {
        var mock = OCMockObject.mock(for: NSString.self)
        mock.verify()
    }
    
}
