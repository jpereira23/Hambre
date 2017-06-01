//
//  RealmDatabaseHandler.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import RealmSwift


// MARK: Model 




class Review: Object {
    dynamic var id = ""
    dynamic var reviewer = ""
    dynamic var review = 0
}

class RealmDatabaseHandler: NSObject {
    public func addReview(review: Review)
    {
        let realm = try! Realm()
        try! realm.write {
            realm.create(Review.self, value: [review.id, review.reviewer, review.review])
        }
        
    }
    
    public func loadRealmDatabase() -> [Review]
    {
        var arrayOfReviews = [Review]()
        let realm = try! Realm()
        let anArray = realm.objects(Review.self)
        
        for object in anArray
        {
            let review = Review()
            review.id = object.id
            review.reviewer = object.reviewer
            review.review = object.review
            arrayOfReviews.append(review)
        }
        
        return arrayOfReviews
    }
}
