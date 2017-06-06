//
//  CloudKitDatabaseHandler.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/1/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CloudKit


protocol CloudKitDatabaseHandlerDelegate
{
    func errorUpdating(_ error: NSError)
    func modelUpdated()
}

class Review: NSObject {
    
    private var record: CKRecord!
    private weak var database : CKDatabase!
    private var id : String!
    private var reviewer : String!
    private var review : Int!
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        
        self.id = record["id"] as! String
        self.review = record["review"] as! Int
        self.reviewer = record["reviewer"] as! String
    }
    
    init(id: String, review: Int, reviewer: String)
    {
        self.record = nil
        self.database = nil
        self.id = id
        self.review = review
        self.reviewer = reviewer
    }
    
    public func getReviewer() -> String
    {
        return self.reviewer
    }
    
    public func getReview() -> Int
    {
        return self.review
    }
    
    public func getId() -> String
    {
        return self.id
    }
}

class CloudKitDatabaseHandler: NSObject {
    let container : CKContainer
    let publicDB : CKDatabase
    var delegate: CloudKitDatabaseHandlerDelegate?
    private var arrayOfReviews: [Review] = []
    public override init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        super.init()
        self.loadDataFromCloudKit()
    }
    
    public func loadDataFromCloudKit()
    {
        let aPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Review", predicate: aPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error as NSError)
                    print("Cloud Query Error - Fetch Reviews: \(error)")
                }
                return
            }
            self.arrayOfReviews.removeAll(keepingCapacity: true)
            
            results?.forEach({ (record: CKRecord) in self.arrayOfReviews.append(Review(record: record, database: self.publicDB))
            })
            DispatchQueue.main.async {
                self.delegate?.modelUpdated()
            }
        }
    }
    public func accessArrayOfReviews() -> [Review]
    {
        return self.arrayOfReviews
    }
    
    public func addToDatabase(review: Review)
    {
        let myRecord = CKRecord(recordType: "Review")
        myRecord.setObject(review.getId() as CKRecordValue?, forKey: "id")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        myRecord.setObject(appDelegate.accessICloudName() as CKRecordValue?, forKey: "reviewer")
        myRecord.setObject(review.getReview() as CKRecordValue?, forKey: "review")
        
        publicDB.save(myRecord, completionHandler: ({returnRecord, error in
            if let err = error
            {
                print("Error occurred saving database: \(err)")
            }
            else
            {
                print("It worked!")
            }
        }))
    }
}
