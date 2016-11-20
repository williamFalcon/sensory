//
//  Address+Persistance.swift
//  911
//
//  Created by William Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import CoreData

extension Address {
  
  override var description: String {
    super.description
    var result = "\(streetAddress!)"
    
    if let apartment = apartment {
      if apartment._length > 0 {
        result += ". Apartment \(apartment)"
      }
    }
    
    if let floor = floor {
      if floor._length > 0 {
        result += ". Floor \(floor)"
      }
    }
    return result
  }
  
  
  class func loadAll() -> [Address]? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")

    do {
      let results = try AppDelegate.MOC().fetch(request)
      return results as? [Address]
    }
    catch {
      print(error)
      return nil
    }
  }
}
