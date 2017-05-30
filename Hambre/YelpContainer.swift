//
//  YelpContainer.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI
import BrightFutures

@objc protocol YelpContainerDelegate
{
    func yelpAPICallback(_ yelpContainer: YelpContainer)
}

class YelpContainer: NSObject, CLLocationManagerDelegate {
    private var arrayOfBusinesses = [YLPBusiness]()
    private var city: String = "Tracy"
    private var state: String = "CA"
    private var location : String!
    private var appId = "M8_cEGzomTyCzwz3BDYY4Q"
    private var appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    var delegate : YelpContainerDelegate!
    
    public override init()
    {
        super.init()
        self.configureCityAndStateWithCoordinate()
        
        self.location = self.createLocation()
        
        // API Call below
        var query : YLPQuery
        
        query = YLPQuery(location: self.location)
        query.term = "mexican"
        query.limit = 50
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                //Fix this, bad practice
                if let _ = search.businesses.last {
                    self.arrayOfBusinesses = search.businesses
                    self.delegate.yelpAPICallback(self)
                    /*
                    for aBusiness in search.businesses
                    {
                        print("Name: \(aBusiness.name) \n Image: \(String(describing: aBusiness.imageURL))")
                        
                    }
                    */ 
                } else {
                    print("No businesses found")
                }
                
            }.onFailure { error in
                print("Search errored: \(error)")
        }
    }
    
    public func getLocation() -> String
    {
        return self.location
    }
    
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfBusinesses
    }
    
    public func getCity() -> String
    {
        return self.city
    }
    
    public func getState() -> String
    {
        return self.state
    }
    
    //Everything below needs to remain private 
    
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
    
    private func configureCityAndStateWithCoordinate()
    {
        let locValue = self.configureCoordinates()
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark : CLPlacemark!
            placeMark = placemarks?[0]
            
            if let state = placeMark.addressDictionary?["State"] as? String {
                self.state = state
                print("State: \(state)")
            }
            
            if let city = placeMark.addressDictionary?["City"] as? String {
                self.city = city
                print("City: \(city)")
                
            }
            
        })

    }
    
    private func createLocation() -> String
    {
        return self.city + ", " + self.state
    }
    
    
}
