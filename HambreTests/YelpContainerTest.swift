//
//  YelpContainerTest.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import XCTest
@testable import Hambre

class YelpContainerTest: XCTestCase {
    
    var yelpContainer = YelpContainer()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfGettingLocationWorks()
    {
        XCTAssertTrue("Tracy, CA" == yelpContainer.getLocation())
    }
    
    /*
    func testIfGettingCoordinatesWork()
    {
        let aCoordinate = yelpContainer.configureCoordinates()
        
        if aCoordinate.longitude == -122.406417
        {
            XCTAssertTrue(aCoordinate.latitude == 37.785834)
        }
    }
    
    func testIfTextLocationWorks()
    {
        //yelpContainer.configureCityAndStateWithCoordinate()
        XCTAssertTrue(true)
    }
    */ 
}
