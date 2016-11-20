//
//  Address+IO.swift
//  911
//
//  Created by Will Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreData

extension ContactViewController {
  
  func deleteAddress() {
    if let address = address {
      AppDelegate.MOC().delete(address)
      do {
        try AppDelegate.MOC().save()
        dismiss(animated: true, completion: {
        })
        
      }catch {
        print(error)
      }
    }
  }
  
  func syncAddress() {
    if address == nil {
      address = Address(context: AppDelegate.MOC())
    }
    address?.apartment = apartmentTextField.text
    address?.floor = floorTextField.text
    address?.streetAddress = addressTextField.text
    address?.nickname = nicknameTextField.text
  }
  
  func saveAddress() {
    syncAddress()
    
    do {
      try AppDelegate.MOC().save()
      onComplete?()
      dismiss(animated: true, completion: {
      })
      
    }catch {
      print(error)
    }
  }
}
