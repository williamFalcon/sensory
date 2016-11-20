//
//  NSManagedObjectContext+SAK.swift
//  Bonobos
//
//  Created by Will Falcon on 8/17/16.
//  Copyright © 2016 Bonobos. All rights reserved.
//

import CoreData
import UIKit

public extension NSManagedObjectContext {
  
  /**
   Enables in memory creation of managedObjects without hitting app persistent store
   */
  class func _InMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
      print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
  }
}
