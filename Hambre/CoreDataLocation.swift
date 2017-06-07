//
//  CoreDataLocation.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/7/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreData

class CoreDataLocation: NSObject {
    private var managedObjects = [NSManagedObject]()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var managedContext : NSManagedObjectContext!
    private var entity : NSEntityDescription!
    
    public override init()
    {
        self.managedContext = self.appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "UserLocation", in: self.managedContext)
    }
    
    public func saveLocation(location: String)
    {
        self.removeEverythingFromCoreData()
        
        let theLocation = NSManagedObject(entity: self.entity!, insertInto: self.managedContext)
        
        theLocation.setValue(location, forKeyPath: "location")
        
        do
        {
            try self.managedContext.save()
            managedObjects.append(theLocation)
            
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
    }
    
    public func loadLocation() -> String
    {
        var tempLocations : [String] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserLocation")
        
        do {
            managedObjects = try self.managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for location in managedObjects
        {
            let aLocation = location.value(forKeyPath: "location") as! String
            
            tempLocations.append(aLocation)
        }
        
        return tempLocations[0]
    }
    
    public func checkIfCoreDataIsEmpty() -> Bool
    {
        var tempLocations : [String] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserLocation")
        
        do {
            managedObjects = try self.managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for location in managedObjects
        {
            let aLocation = location.value(forKeyPath: "location") as! String
            
            tempLocations.append(aLocation)
        }
        
        if tempLocations.count == 0
        {
            return true
        }
        
        return false
    }
    
    private func removeEverythingFromCoreData()
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLocation")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try managedContext.execute(request)
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
    }
    
}
