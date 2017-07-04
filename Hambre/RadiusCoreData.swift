
//
//  RadiusCoreData.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/4/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreData

class RadiusCoreData: NSObject {
    private var managedObjects = [NSManagedObject]()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var managedContext : NSManagedObjectContext!
    private var entity : NSEntityDescription!
    
    public override init()
    {
        self.managedContext = self.appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Radius", in: self.managedContext)
    }
    
    public func saveRadius(distance: Int)
    {
        self.removeEverythingFromCoreData()
        self.managedObjects.removeAll()
        
        let aRadius = NSManagedObject(entity: self.entity!, insertInto: self.managedContext)
        aRadius.setValue(distance, forKeyPath: "distance")
        
        do
        {
            try self.managedContext.save()
            managedObjects.append(aRadius)
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
    }
    
    public func loadRadius() -> Int
    {
        var tempRadius : [Int] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Radius")
        
        do {
            managedObjects = try self.managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for radi in managedObjects
        {
            let aRadius = radi.value(forKeyPath: "distance") as! Int
            
            tempRadius.append(aRadius)
        }
        if tempRadius.count > 0
        {
            return tempRadius[0]
        }
        
        return 0
    }
    
    private func removeEverythingFromCoreData()
    {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Radius")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try managedContext.execute(request)
        } catch let error as NSError {
            print("Could not save. \(error). \(error.userInfo)")
        }
    }
    
    public func checkIfCoreDataIsEmpty() -> Bool
    {
        var tempRadius : [Int] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Radius")
        
        do {
            managedObjects = try self.managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for radi in managedObjects
        {
            let aRadius = radi.value(forKeyPath: "distance") as! Int
            
            tempRadius.append(aRadius)
        }
        
        if tempRadius.count == 0
        {
            return true
        }
        
        return false
    }
}
