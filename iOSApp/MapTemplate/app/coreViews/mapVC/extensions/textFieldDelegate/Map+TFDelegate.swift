//
//  ContactVC+MessageUI.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == addressLabel {
            floorNumberLabel.becomeFirstResponder()
        }else if textField == floorNumberLabel {
            aptNumLabel.becomeFirstResponder()
        }
        return true
    }

}
