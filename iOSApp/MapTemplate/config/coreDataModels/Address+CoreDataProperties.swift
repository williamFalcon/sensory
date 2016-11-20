//
//  Address+CoreDataProperties.swift
//  911
//
//  Created by William Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var nickname: String?
    @NSManaged var floor: String?
    @NSManaged var apartment: String?
    @NSManaged var streetAddress: String?

}
