//
//  Compass+Address.swift
//  MapTemplate
//
//  Created by William Falcon on 8/20/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation

extension Compass {
    
    class func addressFromLocation(_ location:CLLocation!, completionClosure:@escaping ((NSDictionary?)->())){
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
                if let places = placeMarks {
                    let marks = places[0]
                    completionClosure(marks.addressDictionary as NSDictionary?)
                }else {
                    completionClosure(nil)
                }
            })
        })
    }
}
