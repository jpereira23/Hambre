//
//  CloudKitDatabaseHandlerTest.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/1/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import XCTest

@testable import Hambre

var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
class CloudKitDatabaseHandlerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfGettingOneResult()
    {
        let array = cloudKitDatabaseHandler.loadDataFromCloudKit()
        XCTAssertTrue(array.count == 0)
    }
    
}
