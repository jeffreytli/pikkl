//
//  BattleDataModel.swift
//  pikkl
//
//  Created by Jeffrey Li on 10/30/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BattleDataModel {
    
    private var battles = [NSManagedObject]()
    
    init(){
        
    }
    
    // Save the candidate inside our core data
    func saveBattle(objectId: String, name: String, currentPhase: String, timeLeft: String){
        print("Current phase: " + currentPhase)
        
        if (!containsBattle(objectId)){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            // Create the entity that we want to save
            let entity =  NSEntityDescription.entityForName("Battle", inManagedObjectContext: managedContext)
            let battle = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            // Set the attribute values
            battle.setValue(objectId, forKey: "objectId")
            battle.setValue(name, forKey: "name")
            battle.setValue(currentPhase, forKey: "currentPhase")
            battle.setValue(timeLeft, forKey: "timeLeft")
            
            // Commit the changes
            do {
                try managedContext.save()
            } catch {
                // What do we do in case of errors?
                let nsError = error as NSError
                NSLog("Unresolved error \(nsError), \(nsError.userInfo)")
                abort()
            }
            
            // Add the new entity to our array of managed objects
            print("Saving battle to core data")
            self.battles.append(battle)
        } else {
            for battle in self.battles {
                let curObjectId = (battle.valueForKey("objectId") as? String)!
                if (curObjectId == objectId){
                    print("IN HERE")
                    battle.setValue(currentPhase, forKey: "currentPhase")
                    battle.setValue(timeLeft, forKey: "timeLeft")
                }
            }
        }
    }
    
    func getBattles() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Battle")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "timeLeft", ascending: false)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            self.battles = results
        } else {
            print("Could not fetch")
        }
        return self.battles;
    }
    
    func getBattlesCount() -> Int {
        return self.battles.count
    }
    
    func containsBattle(objectId: String) -> Bool {
        let contains = false
        
        for battle in self.battles {
            let curObjectId = (battle.valueForKey("objectId") as? String)!
            if (curObjectId == objectId){
                return true
            }
        }
        
        return contains
    }
}
