
//
//  PersonalBusiness.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import YelpAPI

class PersonalBusiness: Negocio, CLLocationManagerDelegate {
    private var city : String!
    private var state : String!
    private var liked : Bool!
    private var likes : Int!
    private var distance : Int = 0
    private var longitude : Double!
    private var latitude : Double!
    private var phoneNumber : String!
    private var address : String!
    private var isClosed : Bool!
    private var websiteUrl : String!
    private var coordinate : CLLocationCoordinate2D!
    private var fullAddress : String!
    private var zipcode: String!
    
    
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int, longitude: Double, latitude: Double, coordinate: CLLocationCoordinate2D, fullAddress: String)
    {
        super.init(businessName: businessName, businessImageUrl:
            businessImageUrl)
        self.longitude = longitude
        self.latitude = latitude
        self.city = city
        self.state = state
        self.liked = liked
        self.likes = likes
        self.isClosed = false
        self.websiteUrl = "www.google.com"
        self.phoneNumber = "(000) 000 0000"
        self.address = "123 Westwood, Zimbabwe, Africa"
        self.coordinate = coordinate
        self.fullAddress = fullAddress
        self.zipcode = "95376"
       
    }
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int, longitude: Double, latitude: Double, phoneNumber : String, address: [String], isClosed: Bool, websiteUrl: String, coordinate: CLLocationCoordinate2D, zipcode: String)
    {
        super.init(businessName: businessName, businessImageUrl:
            businessImageUrl)
        self.longitude = longitude
        self.latitude = latitude
        
        self.city = city
        self.state = state
        self.liked = liked
        self.likes = likes
        self.distance = self.getADistance()
        self.phoneNumber = phoneNumber
        self.zipcode = zipcode
        if address.count > 0
        {
            self.address = address[0]
            self.fullAddress = self.address + "\n" + self.city + ", " + self.state + " " + self.zipcode
        }
        else
        {
            self.address = "N/A"
            self.fullAddress = self.city + ", " + self.state + " " + self.zipcode
        }
        self.isClosed = isClosed
        self.websiteUrl = websiteUrl
        self.coordinate = coordinate
        
    }
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int, longitude: Double, latitude: Double, phoneNumber : String, theAddress: String, isClosed: Bool, websiteUrl: String, coordinate: CLLocationCoordinate2D, fullAddress: String, zipcode: String)
    {
        super.init(businessName: businessName, businessImageUrl:
            businessImageUrl)
        self.longitude = longitude
        self.latitude = latitude
        self.city = city
        self.state = state
        self.liked = liked
        self.distance = self.getADistance()
        self.likes = likes
        self.phoneNumber = phoneNumber
        self.address = theAddress
        self.isClosed = isClosed
        self.websiteUrl = websiteUrl
        self.coordinate = coordinate
        self.fullAddress = fullAddress
        self.zipcode = zipcode
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
    
    private func setAddress(address: [String]) -> String
    {
        let theAddress = "Something"//theAddress + ", " + self.city + ", " + self.state
        
        
        return theAddress

    }
 
    
    private func getADistance() -> Int
    {
        let coordinate0 : CLLocation!
        if self.coordinate != nil
        {
            coordinate0 = CLLocation(latitude: CLLocationDegrees(self.coordinate.latitude), longitude: CLLocationDegrees(self.coordinate.longitude))
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            coordinate0 = CLLocation(latitude: CLLocationDegrees(appDelegate.getLatitude()), longitude: CLLocationDegrees(appDelegate.getLongitude()))
        }
        
        let coordinate1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        self.distance = Int(Double(coordinate0.distance(from: coordinate1)) * 0.000621371)
        
        return self.distance
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
    
    public func getZipcode() -> String
    {
        return self.zipcode
    }
    
    public func getFullAddress() -> String
    {
        return self.fullAddress
    }
    
    public func getLikes() -> Int
    {
        return self.likes
    }
    
    public func setLiked(liked: Bool)
    {
        self.liked = liked
    }
    
    public func getLongitude() -> Double
    {
        return self.longitude
    }
    
    public func getLatitude() -> Double
    {
        return self.latitude
    }
    
    public func getDistance() -> Int
    {
        return self.distance
    }
    
    public func getNumber() -> String
    {
        return self.phoneNumber
    }
    
    public func getAddress() -> String
    {
        return self.address
    }
    
    public func getIsClosed() -> Bool
    {
        return self.isClosed
    }
    
    public func getWebsiteUrl() -> String
    {
        return self.websiteUrl
    }
}
