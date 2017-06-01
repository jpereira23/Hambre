//
//  RealmDatabaseHandlerTest.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import XCTest
@testable import Hambre
class RealmDatabaseHandlerTest: XCTestCase {
    var realmDatabaseHandler = RealmDatabaseHandler()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckIfAddingWorks() {
        let review = Review()
        review.id = "anId"
        review.reviewer = "Jeff"
        review.review = 3
        
        realmDatabaseHandler.addReview(review: review)
        
        let object = realmDatabaseHandler.loadRealmDatabase()
        
        XCTAssertTrue(object[0].review == 3)
    }
    
}
