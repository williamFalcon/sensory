//
//  Compass+BackgroundLocation.swift
//  MapTemplate
//
//  Created by William Falcon on 8/20/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation

extension Compass {
    //MARK: - Background Location API
    
    /**
     Starts loading locations in background
    */
    class func startMonitoringBackgroundLocation(_ accuracy: CLLocationAccuracy, onUpdate: @escaping ((_ location: CLLocation)->())) {
        let compass = Compass.sharedInstance
        compass.locationUpdateBlock = onUpdate
        compass.locationManager.desiredAccuracy = accuracy
        compass.locationManager.startUpdatingLocation()
    }
    
    
    class func stopMonitoringBackgroundLocation() {
        let compass = Compass.sharedInstance
        compass.locationUpdateBlock = nil
        compass.locationManager.stopUpdatingLocation()
    }
    
    class func startMonitoringVisits(_ visitBlock: @escaping ((_ visit: CLVisit) -> ())) {
        let compass = Compass.sharedInstance
        compass.visitUpdateBlock = visitBlock
        compass.locationManager.startMonitoringVisits()
    }
    
    class func stopMonitoringVisits() {
        let compass = Compass.sharedInstance
        compass.visitUpdateBlock = nil
        compass.locationManager.stopMonitoringVisits()
    }
    
    
    func handleBackgroundLocationUpdates(_ manager: CLLocationManager, locations:[CLLocation]) {
        
        let newLocation = locations.last!
        let mgr = Compass.sharedInstance
        mgr.lastLocation = newLocation
        mgr.locationUpdateBlock?(newLocation)
    }
    
    func handleNewVisit(_ visit: CLVisit) {
        let mgr = Compass.sharedInstance
        mgr.lastVisit = visit
        mgr.visitUpdateBlock?(visit)
    }
}
