//
//  PersonalBusiness.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class PersonalBusiness: Negocio {
    private var city : String!
    private var state : String!
    private var liked : Bool!
    private var likes : Int!
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int)
    {
        super.init(businessName: businessName, businessImageUrl: businessImageUrl)
        self.city = city
        self.state = state
        self.liked = liked
        self.likes = likes
    }
    
    public init()
    {
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")
        super.init(businessName: "", businessImageUrl: url!)
        self.city = ""
        self.state = ""
        self.liked = false
        self.likes = 0
    }
    public func getCity() -> String
    {
        return self.city
    }
    
    public func getState() -> String
    {
        return self.state
    }
    
    public func getLiked() -> Bool
    {
        return self.liked
    }
    
    public func getLikes() -> Int
    {
        return self.likes
    }
}
