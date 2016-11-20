//
//  Map+MapViewDelegate.swift
//  MapTemplate
//
//  Created by William Falcon on 8/18/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 10.0, *)
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    updateAddressFromLoc()
    predictAddressIfNeeded()
  }
  
  func predictAddressIfNeeded() {
    if isMapCenterOnUser() {
        DataCollector.predictLocation({(floor) in
          self.floorNumberLabel.text = "\(floor)"
          }, onFailure: { (error) in
            print(error)
        })
    }
  }
  
  func isMapCenterOnUser() -> Bool {
    if let userLoc = mapView.userLocation.location {
      let center = mapView.centerCoordinate
      let centerLoc = CLLocation(latitude: center.latitude, longitude: center.longitude)
      let distance = userLoc.distance(from: centerLoc)
      return distance < 10.0
    }
    
    return false
  }
  
  func updateAddressFromLoc() {
    let coord = mapView.centerCoordinate
    let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
    Compass.addressFromLocation(loc) { (addressDict) in
      if let formatedAddress = addressDict?["FormattedAddressLines"] as? [String] {
        let address = formatedAddress._joinWithSeparator(", ")
        self.address.streetAddress = address
        self.addressLabel.text = address
      }
    }
  }
}
