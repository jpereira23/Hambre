//
//  AppDelegate.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/28/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import YelpAPI
import BrightFutures
import CoreData 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    private var city: String!
    private var state: String!
    private var arrayOfBusinesses = [YLPBusiness]()
    let appId = "M8_cEGzomTyCzwz3BDYY4Q"
    let appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /*
        self.configureCityAndStateWithCoordinates()
        self.configureYelpBusinesses()
        */ 
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.configureCityAndStateWithCoordinates()
        self.configureYelpBusinesses()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // ## Functions for CoreData 
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        
        let container = NSPersistentContainer(name: "Negocios")
        //let description = NSPersistentStoreDescription()
        
        //description.shouldInferMappingModelAutomatically = true
        //description.shouldMigrateStoreAutomatically = true
        
        //container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // ##Public functions to retrieve information
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
    
    
    // ##Private functions to configure city and coordinates
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
                    self.arrayOfBusinesses = search.businesses
                    for aBusiness in search.businesses
                    {
                        print("Name: \(aBusiness.name) \n Image: \(String(describing: aBusiness.imageURL))")
                        
                    }
                } else {
                    print("No businesses found")
                }
               
            }.onFailure { error in
                print("Search errored: \(error)")
        }
    }
}


