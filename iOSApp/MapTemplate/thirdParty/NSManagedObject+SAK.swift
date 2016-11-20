//
//  NSManagedObject.swift
//  Bonobos
//
//  Created by Will Falcon on 8/16/16.
//  Copyright © 2016 Bonobos. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObject {
  
  /**
   Create in a desired MOC or as an unassociated object
   
   - parameter managedObjectContext: MOC in charge of this object
   - parameter dissasociated: If true, object will not belong to any context
   
   - returns: New NSManagedObject
   */
//  convenience init(_managedObjectContext moc: NSManagedObjectContext, _dissasociated dissasociated: Bool) {
//    
//    let entityName = NSStringFromClass(type(of: self))._splitOn(".").last!
//    let entity = NSEntityDescription.entity(forEntityName: entityName, in: moc)!
//    
//    //init in a MOC if given but otherwise create a dissasociated object
//    self(entity: entity, insertInto: dissasociated ? nil : moc)
//  }
  
}
