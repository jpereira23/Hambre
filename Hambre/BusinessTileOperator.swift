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

class BusinessTileOperator: NSObject {
    private var arrayOfBusinesses = [PersonalBusiness]()
    private var arrayOfRightBusinesses = [PersonalBusiness]()
    private var arrayOfLeftBusinesses = [PersonalBusiness]()
    private var globalIndexForCurrentCompany = 0
    private var arrayOfNegocios = [YLPBusiness]()
    private var personalBusinessCoreData = PersonalBusinessCoreData()
    
    let appId = "M8_cEGzomTyCzwz3BDYY4Q"
    let appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    
    public init(anArrayOfBusinesses: [YLPBusiness], city: String, state: String)
    {
        super.init()
        
        for business in anArrayOfBusinesses
        {
            
            let personalBusiness : PersonalBusiness!
            if business.imageURL != nil
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: city, state: state, liked: false, likes: 0, longitude: Float(business.location.coordinate!.longitude), latitude: Float(business.location.coordinate!.latitude))
            }
            else
            {
                personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/59/Facultat_Filosofia_URL.JPG")!, city: city, state: state, liked: false, likes: 0, longitude: Float(business.location.coordinate!.longitude), latitude: Float(business.location.coordinate!.latitude))
                
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
    }
    
    private func populateArraysOfBusinesses()
    {
        for business in self.arrayOfNegocios
        {
            if business.name != "" && business.imageURL != nil
            {
                let personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: "Tracy", state: "CA", liked: false, likes: 0, longitude: Float(business.location.coordinate!.longitude), latitude: Float(business.location.coordinate!.latitude))
            
                self.arrayOfBusinesses.append(personalBusiness)
                self.arrayOfLeftBusinesses.append(personalBusiness)
            }
        }
    }
    
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfNegocios
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
