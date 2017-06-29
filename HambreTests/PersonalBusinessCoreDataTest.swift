//
//  PersonalBusinessCoreDataTest.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import XCTest

@testable import Hambre
class PersonalBusinessCoreDataTest: XCTestCase {
    var personalBusinessCoreData = PersonalBusinessCoreData()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveBusiness()
    {
        personalBusinessCoreData.resetCoreData()
        //let personalBusiness = PersonalBusiness(businessName: "Jeffs", businessImageUrl: URL(string:"https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")!, city: "Tracy", state: "CA", liked: true, likes: 1)
        //self.personalBusinessCoreData.saveBusiness(personalBusiness: personalBusiness)
    }
    
    func testIfLoadingBusinesses()
    {
        XCTAssertTrue(personalBusinessCoreData.loadCoreData().count == 1)
    }
    
    func testIfLoadingWorksPartTwo()
    {
        let personalBusiness = personalBusinessCoreData.loadCoreData()[0]
        
        XCTAssertTrue(personalBusiness.getBusinessName() == "Jeffs")
    }
    
    
    
}
