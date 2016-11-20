//
//  AddressbookViewController.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

class AddressbookViewController: UIViewController {
  
  //MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var rightNavButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var leftNavButton: UIButton!
  
  var data: [Address] = []
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
    if let data = Address.loadAll() {
      self.data = data
    }
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func leftNavButtonPressed(_ sender: UIButton) {
    dismiss(animated: true) {}
  }
  
  @IBAction func rightNavButtonPressed(_ sender: UIButton) {
    if tableView.isEditing {
      tableView.isEditing = false
      rightNavButton.setTitle("Edit", for: UIControlState())
      leftNavButton.isHidden = false
    }else {
      tableView.isEditing = true
      rightNavButton.setTitle("Done", for: UIControlState())
      leftNavButton.isHidden = true
    }
  }
}
