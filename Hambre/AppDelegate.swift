//
//  AppDelegate.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/28/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

import CoreData 
import CloudKit
import GooglePlaces
import GoogleMaps
import SystemConfiguration


protocol AppDelegateDelegate
{
    func locationServicesUpdated(appDelegate: AppDelegate)
}


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    private var locationManager = CLLocationManager()
    private var iCloudName : String! = "User not available/Or user was recently added"
    private var theCoordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
    private var city = "San Francisco"
    private var state = "California"
    private var latitude: Double = 0000
    private var longitude: Double = 00000
    private var locationSwitch = false
    private var locationEnabled = true
    var delegate: AppDelegateDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.locationManager.delegate = self
        /*
        if self.isInternetAvailable()
        {
            self.configueCoordinates()
        }
        */
        //make status bar white
        UIApplication.shared.statusBarStyle = .lightContent
        
        GMSPlacesClient.provideAPIKey("AIzaSyDk7lsxhuYxuVG0WeYOh0t3Wg7Yu78MM74")
        GMSServices.provideAPIKey("AIzaSyDk7lsxhuYxuVG0WeYOh0t3Wg7Yu78MM74")
        
        self.getICloudAccess()
        
        return true
    }
    
    public func getICloudAccess()
    {
        CKContainer.default().accountStatus {
            (status: CKAccountStatus, error: Error?) in
            DispatchQueue.main.async(execute: {
                if error != nil{
                    print(error!)
                } else {
                    
                    switch status{
                    case .available:
                        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                            CKContainer.default().fetchUserRecordID { (record, error) in
                                CKContainer.default().discoverUserIdentity(withUserRecordID: record!, completionHandler: { (userID, error) in
                                    if error != nil  {
                                        self.iCloudName = "User not available/Or user was recently added"
                                        
                                    } else {
                                        self.iCloudName = ((userID?.nameComponents?.givenName)! + " " + (userID?.nameComponents?.familyName)!)
                                    }
                                    
                                })
                                
                            }
                            
                        }
                    default:
                        print("iCloud is not available")
                    }
                    
                }
            })
        }
    }
    
    public func checkForLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .restricted, .denied:
                self.delegate?.locationServicesUpdated(appDelegate: self)
                self.locationEnabled = false
                break
            default:
                print("Nothing works")
            }
        }
    }
    
    public func isLocationEnabled() -> Bool
    {
        return self.locationEnabled
    }
    
    public func configueCoordinates()
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    public func getLongitude() -> Double
    {
        return self.longitude
    }
    
    public func getLatitude() -> Double
    {
        return self.latitude
    }
    
    public func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    public func getCityAndState() -> String
    {
        return self.city +  ", " + self.state
    }
    
    public func getCity() -> String
    {
        return self.city
    }
    
    public func getState() -> String
    {
        return self.state 
    }
    
    public func getCoordinate() -> CLLocationCoordinate2D
    {
        return self.theCoordinate
    }
    
    private func configureCityAndStateWithCoordinate()
    {
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: self.theCoordinate.latitude, longitude: self.theCoordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark : CLPlacemark!
            placeMark = placemarks?[0]
            if placeMark != nil
            {
                if let state = placeMark.addressDictionary?["State"] as? String {
                    self.state = state
                    print("State: \(state)")
                }
                
                if let city = placeMark.addressDictionary?["City"] as? String {
                    self.city = city
                    print("City: \(city)")
                    
                }
            }
            self.delegate?.locationServicesUpdated(appDelegate: self)
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if self.locationSwitch == false
        {
            self.locationSwitch = true
            self.theCoordinate = (manager.location?.coordinate)!
            self.configureCityAndStateWithCoordinate()
            
            self.longitude = Double((manager.location?.coordinate.longitude)!)
            self.latitude = Double((manager.location?.coordinate.latitude)!)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
        
        if locationSwitch != false && self.isInternetAvailable()
        {
            locationSwitch = false
            self.configueCoordinates()
        }
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    public func accessICloudName() -> String
    {
        return self.iCloudName
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
}


