//
//  Map+Transitions.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation

@available(iOS 10.0, *)
extension MapViewController {
  
  func showAddressbook() {
    let vc = AddressbookViewController._newInstance() as! AddressbookViewController
    addressbookVC = vc
    self.present(vc, animated: true) {
      
    }
  }
  
  func showContactVC() {
    syncAddress()
    let vc = ContactViewController._newInstance() as! ContactViewController
    contactVC = vc
    vc.address = address
    self.present(vc, animated: true) {
      
    }
  }
  
  func syncAddress() {
    address.streetAddress = addressLabel.text
    address.apartment = aptNumLabel.text
    address.floor = floorNumberLabel.text
  }
  
  func showSaveAddressVC() {
    syncAddress()
    let vc = ContactViewController._newInstance() as! ContactViewController
    contactVC = vc
    vc.pageMode = .save

    vc.address = address
    AppDelegate.MOC().insert(address)
    self.present(vc, animated: true) {
      
    }
  }
}
