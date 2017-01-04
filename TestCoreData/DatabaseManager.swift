//
//  DatabaseManager.swift
//  TestCoreData
//
//  Created by Toseefhusen Khilji on 30/12/16.
//  Copyright © 2016 Toseef Khilji. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager{
    
    private init(){
        
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TestCoreData")
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
    
    class func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
   class func saveContext () {
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

    
    // MARK: - Core Data custom operations
    
    // Gets all.
   class func getAll() -> [Student]{
        return get(withPredicate: NSPredicate(value:true))
    }
    
    // Gets a Student by id
  class  func getById(id: NSManagedObjectID) -> Student? {
        return DatabaseManager.getContext().object(with: id) as? Student
    }
    
    // Gets all that fulfill the specified predicate.
    // Predicates examples:
    // - NSPredicate(format: "name == %@", "Juan Carlos")
    // - NSPredicate(format: "name contains %@", "Juan")
   class func get(withPredicate queryPredicate: NSPredicate) -> [Student]{
        let fetchRequest  : NSFetchRequest <Student> = Student.fetchRequest()
        
        fetchRequest.predicate = queryPredicate
        
        do {
            let response = try DatabaseManager.getContext().fetch(fetchRequest)
            return response
            
        } catch let error as NSError {
            // failure
            print(error)
            return [Student]()
        }
    }
    
    class func delete(student stud: Student) -> Bool{
        
        DatabaseManager.getContext().delete(stud)
        do{
            try DatabaseManager.getContext().save()
            return true
        }
        catch {
            return false
        }
    }
}
