//
//  AppDelegateTest.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import XCTest
@testable import Hambre

class AppDelegateTest: XCTestCase {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBusinesses()
    {
        let array = appDelegate?.getBusinesses()
        XCTAssertTrue((array?.count)! > 0)
    }
    
    func testCity()
    {
        let city = appDelegate?.getCity()
        XCTAssertTrue(city == "San Francisco")
    }
    
    func testState()
    {
        let state = appDelegate?.getState()
        XCTAssertTrue(state == "CA")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
