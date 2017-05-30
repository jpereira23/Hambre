//
//  BusinessTileOperator.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class BusinessTileOperator: NSObject {
    private var arrayOfBusinesses = [PersonalBusiness]()
    private var arrayOfRightBusinesses = [PersonalBusiness]()
    private var arrayOfLeftBusinesses = [PersonalBusiness]()
    private var globalIndexForCurrentCompany = 0
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public override init()
    {
        for business in appDelegate.getBusinesses()
        {
            let personalBusiness = PersonalBusiness(businessName: business.name, businessImageUrl: business.imageURL!, city: appDelegate.getCity(), state: appDelegate.getState(), liked: false, likes: 0)
            
            self.arrayOfBusinesses.append(personalBusiness)
            self.arrayOfLeftBusinesses.append(personalBusiness)
            
        }
    }
    
    private func updateUserGeneratedData()
    {
        
    }
    
    public func swipeLeft()
    {
        self.checkAndUpdateGlobalIndex()
    }
    
    public func swipeRight()
    {
        self.arrayOfRightBusinesses.append(self.arrayOfLeftBusinesses[self.globalIndexForCurrentCompany])
        self.arrayOfLeftBusinesses.remove(at: self.globalIndexForCurrentCompany)
        
        self.checkAndUpdateGlobalIndex()
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
