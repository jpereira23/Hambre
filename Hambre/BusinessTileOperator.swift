//
//  BusinessTileOperator.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI
import BrightFutures

class BusinessTileOperator: NSObject, CLLocationManagerDelegate {
    private var arrayOfBusinesses = [PersonalBusiness]()
    private var arrayOfRightBusinesses = [PersonalBusiness]()
    private var arrayOfLeftBusinesses = [PersonalBusiness]()
    private var globalIndexForCurrentCompany = 0
    private var city: String!
    private var state: String!
    private var arrayOfNegocios = [YLPBusiness]()
    let appId = "M8_cEGzomTyCzwz3BDYY4Q"
    let appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    
    public override init()
    {
        super.init()
        self.configureCityAndStateWithCoordinates()
        self.configureYelpBusinesses()
        for business in self.arrayOfNegocios
        {
            let personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: self.getCity(), state: self.getState(), liked: false, likes: 0)
            
            self.arrayOfBusinesses.append(personalBusiness)
            self.arrayOfLeftBusinesses.append(personalBusiness)
            self.populateArraysOfBusinesses()
        }
    }
    
    private func populateArraysOfBusinesses()
    {
        for business in self.arrayOfNegocios
        {
            if business.name != "" && business.imageURL != nil
            {
                let personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: "Tracy", state: "CA", liked: false, likes: 0)
            
                self.arrayOfBusinesses.append(personalBusiness)
                self.arrayOfLeftBusinesses.append(personalBusiness)
            }
        }
    }
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfNegocios
    }
    
    public func getCity() -> String
    {
        return self.city
    }
    
    public func getState() -> String
    {
        return self.state
    }
    
    private func updateUserGeneratedData()
    {
        
    }
    
    public func swipeLeft()
    {
        if self.arrayOfLeftBusinesses.count > 0
        {
            self.checkAndUpdateGlobalIndex()
    
        }
    }
    
    public func swipeRight()
    {
        if self.arrayOfLeftBusinesses.count > 0
        {
            self.arrayOfRightBusinesses.append(self.arrayOfLeftBusinesses[self.globalIndexForCurrentCompany])
            self.arrayOfLeftBusinesses.remove(at: self.globalIndexForCurrentCompany)
        
            self.checkAndUpdateGlobalIndex()
        }
    }
    
    public func presentCurrentBusiness() -> PersonalBusiness
    {
        if self.arrayOfLeftBusinesses.count > 0
        {
            return self.arrayOfLeftBusinesses[self.globalIndexForCurrentCompany]
        }
        let fillerPersonalBusiness = PersonalBusiness()
        
        return fillerPersonalBusiness
    }
    
    private func checkAndUpdateGlobalIndex()
    {
        if (self.globalIndexForCurrentCompany + 1) >= self.arrayOfLeftBusinesses.count
        {
            self.globalIndexForCurrentCompany = 0
        }
        else
        {
            self.globalIndexForCurrentCompany = self.globalIndexForCurrentCompany + 1
        }
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
    
    private func configureCityAndStateWithCoordinates()
    {
        let locValue = self.configureCoordinates()
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark : CLPlacemark!
            placeMark = placemarks?[0]
            
            if let state = placeMark.addressDictionary?["State"] as? String {
                self.state = state
            }
            
            if let city = placeMark.addressDictionary?["City"] as? String {
                self.city = city
            }
            
        })
    }
    
    // ##Private function to configure all the businesses for Yelp
    
    private func configureYelpBusinesses()
    {
        
        var query : YLPQuery
        if self.state == nil && self.city == nil
        {
            query = YLPQuery(location: "Tracy, CA")
        }
        else
        {
            let cityState = self.city + ", " + self.state
            query = YLPQuery(location: cityState)
        }
        query.term = "mexican"
        query.limit = 50
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                //Fix this, bad practice
                if let topBusiness = search.businesses.last {
                    self.arrayOfNegocios = search.businesses
                    for aBusiness in search.businesses
                    {
                        print("Name: \(aBusiness.name) \n Image: \(String(describing: aBusiness.imageURL))")
                        
                    }
                    self.populateArraysOfBusinesses()
                } else {
                    print("No businesses found")
                }
                
            }.onFailure { error in
                print("Search errored: \(error)")
        }
    }
}
