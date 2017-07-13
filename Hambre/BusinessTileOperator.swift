//
//  BusinessTileOperator.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures
import CoreLocation

class BusinessTileOperator: NSObject {
    private var arrayOfBusinesses = [PersonalBusiness]()
    private var arrayOfRightBusinesses = [PersonalBusiness]()
    private var arrayOfLeftBusinesses = [PersonalBusiness]()
    private var globalIndexForCurrentCompany = 0
    private var arrayOfNegocios = [YLPBusiness]()
    private var personalBusinessCoreData : PersonalBusinessCoreData!
    private var city = "San Francisco"
    private var state = "California"
    private var coordinate : CLLocationCoordinate2D!
    
    let appId = "M8_cEGzomTyCzwz3BDYY4Q"
    let appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    
    public init(city: String, state: String, coordinate: CLLocationCoordinate2D)
    {
        super.init()
        self.city = city
        self.state = state
        self.coordinate = coordinate
        self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: self.coordinate)
    }
    
    public func addBusinesses(arrayOfBusinesses: [YLPBusiness])
    {
        self.personalBusinessCoreData.reloadCoreData()
        self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: self.coordinate)
        
        for business in arrayOfBusinesses
        {
            
            let personalBusiness : PersonalBusiness!
            if business.imageURL == nil && business.phone == nil && business.location.coordinate == nil
            {
                
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.longitude, latitude: self.coordinate.latitude, phoneNumber: "(000) 000-0000", address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.phone == nil && business.location.coordinate == nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.longitude, latitude: self.coordinate.latitude, phoneNumber: "(000) 000-0000", address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.imageURL == nil && business.location.coordinate == nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.latitude, latitude: self.coordinate.longitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.imageURL == nil
            {
                break
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: business.location.coordinate!.longitude, latitude: business.location.coordinate!.latitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.phone == nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.longitude, latitude: self.coordinate.latitude, phoneNumber: "(000) 000-0000", address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.location.coordinate == nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.longitude, latitude: self.coordinate.latitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else if business.location.coordinate == nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: self.coordinate.longitude, latitude: self.coordinate.latitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            }
            else
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: business.location.city, state: business.location.stateCode, liked: false, likes: 0, longitude: business.location.coordinate!.longitude, latitude: business.location.coordinate!.latitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
                
            }
            
            self.arrayOfBusinesses.append(personalBusiness)
            if !personalBusinessCoreData.checkForDuplicates(personalBusiness: personalBusiness)
            {
                self.arrayOfLeftBusinesses.append(personalBusiness)
                self.populateArraysOfBusinesses()
            }
            else
            {
                personalBusiness.setLiked(liked: true)
                self.arrayOfRightBusinesses.append(personalBusiness)
            }
        }
        self.arrayOfLeftBusinesses.shuffle()

    }
    
    public func setTheCoordinate(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate 
    }
    
    public func removeAllBusinesses()
    {
        self.arrayOfLeftBusinesses.removeAll()
        self.arrayOfRightBusinesses.removeAll()
        self.arrayOfBusinesses.removeAll()
    }
    
    private func populateArraysOfBusinesses()
    {
        for business in self.arrayOfNegocios
        {
            if business.name != "" && business.imageURL != nil
            {
                let personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: self.city, state: self.state, liked: false, likes: 0, longitude: business.location.coordinate!.longitude, latitude: business.location.coordinate!.latitude, phoneNumber: business.phone!, address: business.location.address, isClosed: business.isClosed, websiteUrl: business.url.absoluteString, coordinate: self.coordinate, zipcode: business.location.postalCode)
            
                self.arrayOfBusinesses.append(personalBusiness)
                self.arrayOfLeftBusinesses.append(personalBusiness)
            }
        }
    }
    
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfNegocios
    }
    
    public func obtainBusinessesForCards() -> [PersonalBusiness]
    {
        return self.arrayOfLeftBusinesses
    }
    
    private func updateUserGeneratedData()
    {
        
    }
    public func startedOver() -> Bool
    {
        if self.globalIndexForCurrentCompany == 0
        {
            return true
        }
        
        return false
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
            self.personalBusinessCoreData.saveBusiness(personalBusiness: self.arrayOfLeftBusinesses[self.globalIndexForCurrentCompany])
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
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
