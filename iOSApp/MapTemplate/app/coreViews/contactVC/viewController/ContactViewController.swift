//
//  ContactViewController.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {
  
  enum PageMode {
    case call
    case edit
    case save
  }
  
  @IBOutlet weak var mainActionHolderView: UIView!
  @IBOutlet weak var rightNavButton: UIButton!
  @IBOutlet weak var leftNavButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var floorTextField: UITextField!
  @IBOutlet weak var apartmentTextField: UITextField!
  @IBOutlet weak var nicknameTextField: UITextField!
  
  @IBOutlet weak var messageButton: UIButton!
  @IBOutlet weak var callButton: UIButton!
  
  var pageMode: PageMode = .call
  var address: Address?
  var onComplete: (() -> ())?
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !initialDesignApplied {
      initialDesignApplied = true
      applyLayout()
    }
  }
  
  @IBAction func callButtonPressed(_ sender: UIButton) {
    let url = URL(string: "tel://911")!
    UIApplication.shared.openURL(url)
  }
  
  @IBAction func textButtonPressed(_ sender: UIButton) {
    sendMessage()
  }
  @IBAction func viewTapped(_ sender: AnyObject) {
    view.endEditing(true)
  }
  
  @IBAction func leftNavButtonPressed(_ sender: UIButton) {
    self.dismiss(animated: true) {
      
    }
  }
  
  @IBAction func rightNavButtonPressed(_ sender: UIButton) {
    saveAddress()
  }
}







