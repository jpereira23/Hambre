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
    private var ylpBusiness : YLPBusiness! = nil
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int, longitude: Double, latitude: Double)
    {
        super.init(businessName: businessName, businessImageUrl:
            businessImageUrl)
        self.longitude = longitude
        self.latitude = latitude
        self.getDistance(longitude: longitude, latitude: latitude)
        self.city = city
        self.state = state
        self.liked = liked
        self.likes = likes
    }
    
    public init(businessName: String, businessImageUrl: URL, city: String, state: String, liked: Bool, likes: Int, longitude: Double, latitude: Double, ylpBusiness: YLPBusiness)
    {
        super.init(businessName: businessName, businessImageUrl:
            businessImageUrl)
        self.longitude = longitude
        self.latitude = latitude
        self.getDistance(longitude: longitude, latitude: latitude)
        self.city = city
        self.state = state
        self.liked = liked
        self.likes = likes
        self.ylpBusiness = ylpBusiness
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
    
    
    private func configureCoordinates() -> CLLocationCoordinate2D
    {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        return locationManager.location!.coordinate
    }
    
    private func getDistance(longitude: Double, latitude: Double)
    {
        
        //let coordinate0 = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        /*
        let aPotentialCoordinate = self.configureCoordinates()
        let coordinate1 = CLLocation(latitude: aPotentialCoordinate.latitude, longitude: aPotentialCoordinate.longitude)
        
        self.distance = Int(Double(coordinate0.distance(from: coordinate1)) * 0.000621371)
        */
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
}
