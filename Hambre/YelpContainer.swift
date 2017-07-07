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
import CloudKit


protocol CloudKitYelpApiDelegate
{
    func errorUpdating(_ error: NSError)
    func modelUpdated(cloudKitYelpApi: CloudKitYelpApi)
}

class YelpKeys: NSObject
{
    private var record: CKRecord!
    private weak var database: CKDatabase!
    private var appId: String!
    private var appSecret: String!
    
    init(record: CKRecord, database: CKDatabase)
    {
        self.record = record
        self.database = database
        
        self.appId = record["appId"] as! String
        self.appSecret = record["appSecret"] as! String
        
    }
    
    public func getAppId() -> String
    {
        return self.appId
    }
    
    public func getAppSecret() -> String
    {
        return self.appSecret
    }
}

class CloudKitYelpApi: NSObject
{
    let container : CKContainer!
    let publicDB : CKDatabase!
    
    private weak var database: CKDatabase!
    private var yelpKey : YelpKeys!
    var delegate: CloudKitYelpApiDelegate?
    
    public override init()
    {
        self.container = CKContainer.default()
        self.publicDB = container.publicCloudDatabase
        self.yelpKey = nil
        super.init()
        self.loadKeysFromCloudKit()
    }
    
    public func loadKeysFromCloudKit()
    {
        let aPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "YelpKeys", predicate: aPredicate)
        
        self.publicDB.perform(query, inZoneWith: nil) { results, error in
            if let error = error
            {
                DispatchQueue.main.async {
                    self.delegate?.errorUpdating(error as NSError)
                    print("Cloud Query Error - Fetch YelpKeys: \(error)")
                }
                return
            }
            results?.forEach({ (record: CKRecord) in self.yelpKey = YelpKeys(record: record, database: self.publicDB)
            })
            DispatchQueue.main.async {
                self.delegate?.modelUpdated(cloudKitYelpApi: self)
            }
        }
    }
    
    public func getAppId() -> String
    {
        return self.yelpKey.getAppId()
    }
    
    public func getAppSecret() -> String
    {
        return self.yelpKey.getAppSecret()
    }
}

@objc protocol YelpContainerDelegate
{
    func yelpAPICallback(_ yelpContainer: YelpContainer)
    func yelpLocationCallback(_ yelpContainer: YelpContainer)
}

class YelpContainer: NSObject {
    private var arrayOfBusinesses = [YLPBusiness]()
    private var location : String!
    private var appId = "M8_cEGzomTyCzwz3BDYY4Q"
    private var appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    private var cloudKitYelpApi = CloudKitYelpApi()
    private var genre = "restaurants"
    private var theCoordinate : CLLocationCoordinate2D!
    private var locationManager = CLLocationManager()
    var delegate : YelpContainerDelegate!
    
    public init(cityAndState: String)
    {
        super.init()
        self.location = cityAndState
        self.cloudKitYelpApi.delegate = self
        self.cloudKitYelpApi.loadKeysFromCloudKit()
    }
    
    
    deinit{
        self.delegate = nil
        self.arrayOfBusinesses.removeAll()
        
    }
    
    public func setAppId(appId: String)
    {
        self.appId = appId
    }
    
    public func setAppSecret(appSecret: String)
    {
        self.appSecret = appSecret
    }
    
    public func changeGenre(genre: String)
    {
        self.genre = genre
    }
    
    public func setCityState(cityState: String)
    {
        self.location = cityState
    }
    
    public func yelpAPICallForBusinesses()
    {
        
        // API Call below
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.isInternetAvailable()
        {
            var query : YLPQuery
            query = YLPQuery(location: self.location)
            query.term = self.genre
            query.limit = 50
            YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
                client.search(withQuery: query)
                }.onSuccess { search in
                    //Fix this, bad practice
                    if let _ = search.businesses.last {
                        self.arrayOfBusinesses += search.businesses
                        self.delegate.yelpAPICallback(self)
                        /*
                         
                         This is how you can get business names and other attributes about YLPBusiness
                         
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
    }
    
    public func getCity() -> String
    {
        let delimiter = ","
        var token = self.location.components(separatedBy: delimiter)
        
        return token[0]
    }
    
    public func getState() -> String
    {
        let delimiter = " "
        var token = self.location.components(separatedBy: delimiter)
        return token[0]
    }
    
    public func getLocation() -> String
    {
        return self.location
    }
    
    public func getBusinesses() -> [YLPBusiness]
    {
        return self.arrayOfBusinesses
    }
    
    public func setCoordinate(coordinate: CLLocationCoordinate2D)
    {
        self.theCoordinate = coordinate
    }
    
    public func getCoordinate() -> CLLocationCoordinate2D
    {
        return self.theCoordinate
    }
}

extension YelpContainer : CloudKitYelpApiDelegate
{
    func errorUpdating(_ error: NSError)
    {
        print("Shit dont work")
    }
    
    func modelUpdated(cloudKitYelpApi: CloudKitYelpApi) {
        print("So far so good")
        self.setAppId(appId: cloudKitYelpApi.getAppId())
        self.setAppSecret(appSecret: cloudKitYelpApi.getAppSecret())
        
    }
}
