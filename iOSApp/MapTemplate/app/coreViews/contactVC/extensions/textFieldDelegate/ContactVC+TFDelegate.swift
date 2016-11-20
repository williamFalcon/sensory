//
//  ContactVC+MessageUI.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

extension ContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nicknameTextField {
            addressTextField.becomeFirstResponder()
        }else if textField == addressTextField {
            floorTextField.becomeFirstResponder()
        }else if textField == floorTextField {
            apartmentTextField.becomeFirstResponder()
        }
        return true
    }

}
