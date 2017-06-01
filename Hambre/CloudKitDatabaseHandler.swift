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
        
        self.id = record["id"] as? String
        self.review = record["review"] as? Int
        self.reviewer = record["reviewer"] as? String
    }
    
    public func getReviewer() -> String
    {
        return self.reviewer
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
    
    private func loadDataFromCloudKit()
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
}
