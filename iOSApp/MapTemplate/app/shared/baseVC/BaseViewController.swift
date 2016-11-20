//
//  BaseViewController.swift
//  Pokecast
//
//  Created by William Falcon on 7/18/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var initialDesignApplied = false
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (alert) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true) {
            
        }
    }
    
    func showAlert(title: String, message: String, onDismiss:(()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { (alert) in
            onDismiss?()
        }
        alert.addAction(action)
        self.present(alert, animated: true) {
            
        }
    }
}
