//
//  Map+LocationManager.swift
//  MapTemplate
//
//  Created by William Falcon on 8/18/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension MapViewController {
    
    func locateUserOnMap() {
        if CLLocationManager.authorizationStatus() == .denied {
            showAlert(title: "Enable Locations", message: "Can't find you without location enabled!")
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            initLocationManager()
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        }
    }
    
    func initLocationManager() {
        if locationManager == nil {
            let mgr = CLLocationManager()
            mgr.delegate = self
            
            //need best for indoors
            mgr.desiredAccuracy = kCLLocationAccuracyBest
            locationManager = mgr
        }
        
        
        //allow location updates even in background
        locationManager?.requestAlwaysAuthorization()
    }
}
