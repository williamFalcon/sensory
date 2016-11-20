//
//  Session+CoreDataProperties.swift
//  911
//
//  Created by William Falcon on 8/28/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Session {

    @NSManaged var id: String?
    @NSManaged var data: String?
    @NSManaged var envContext: String?
    @NSManaged var cityName: String?
    @NSManaged var countryName: String?

}
