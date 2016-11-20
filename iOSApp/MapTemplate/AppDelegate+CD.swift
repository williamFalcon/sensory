//
//  AppDelegate+CD.swift
//  911
//
//  Created by William Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import CoreData

extension AppDelegate {
    
    class func MOC() -> NSManagedObjectContext {
        let ad = UIApplication.shared.delegate as! AppDelegate
        return ad.managedObjectContext
    }
}
