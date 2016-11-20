//
//  ContactVC+Layout.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

extension ContactViewController {
  
  func applyLayout() {
    designRightNavButton()
    displayAddress()
    
    callButton._setBackgroundTintColor(color: UIColor.red, forState: .normal)
    messageButton._setBackgroundTintColor(color: UIColor.red, forState: .normal)
  }
  
  func displayAddress() {
    if let address = address {
      nicknameTextField.text = address.nickname
      addressTextField.text = address.streetAddress
      floorTextField.text = address.floor
      apartmentTextField.text = address.apartment
    }
  }
  
  func designRightNavButton() {
    leftNavButton.setTitle("Cancel", for: .normal)
    
    switch pageMode {
    case .edit:
      rightNavButton.isHidden = false
      rightNavButton.setTitle("Save", for: .normal)
      titleLabel.text = "Edit Saved Address"
    case .save:
      rightNavButton.isHidden = false
      rightNavButton.setTitle("Save", for: .normal)
      titleLabel.text = "Save New Address"
    default:
      titleLabel.text = "Contact 911"
      rightNavButton.isHidden = true
      mainActionHolderView.isHidden = false
    }
  }
}
