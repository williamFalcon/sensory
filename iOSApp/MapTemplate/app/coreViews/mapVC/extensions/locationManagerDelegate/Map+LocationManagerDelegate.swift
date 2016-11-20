//
//  MapView+LocationManagerDelegate.swift
//  Pokecast
//
//  Created by William Falcon on 7/17/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

@available(iOS 10.0, *)
extension MapViewController: CLLocationManagerDelegate {
  
  // MARK: - CLLocation Delegate
  private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
  }
  
  private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //get last location
    let latestLocation: CLLocation = locations[locations.count - 1]
    self.lastLocation = latestLocation
  }
  
  
}
