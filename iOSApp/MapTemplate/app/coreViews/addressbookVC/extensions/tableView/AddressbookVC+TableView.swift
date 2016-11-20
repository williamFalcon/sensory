//
//  AddressbookVC+TableView.swift
//  911
//
//  Created by William Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

extension AddressbookViewController: UITableViewDataSource, UITableViewDelegate {
  
  func registerCells() {
    AddressTableViewCell._registerToTableView(tableView)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell._identifier(), for: indexPath) as! AddressTableViewCell
    
    let address = data[indexPath.row]
    cell.subtitleLabel.text = address.nickname
    cell.titleLabel.text = "\(address.description)"
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      deleteAddress(indexPath)
    }
  }
  
  func deleteAddress(_ indexPath: IndexPath) {
    let address = data[indexPath.row]
    data.remove(at: indexPath.row)
    AppDelegate.MOC().delete(address)
    self.tableView.reloadData()
    
    do {
      try AppDelegate.MOC().save()
    }catch {
      print(error)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let address = data[indexPath.row]
    let vc = ContactViewController._newInstance() as! ContactViewController
    vc.address = address
    vc.pageMode = .edit
    vc.onComplete = {
      self.tableView.reloadData()
    }
    
    present(vc, animated: true) {
      
    }
  }
  
}
