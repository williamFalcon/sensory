//
//  Compass+LocManagerDelegate.swift
//  MapTemplate
//
//  Created by William Falcon on 8/20/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation


extension Compass: CLLocationManagerDelegate {
    //MARK: - CLLocationManagerDelegate
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        handleBackgroundLocationUpdates(manager, locations: locations)
    }

    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        handleNewVisit(visit)
    }
}
