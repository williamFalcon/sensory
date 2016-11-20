//
//  MapViewController.swift
//  MapTemplate
//
//  Created by William Falcon on 8/18/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import MapKit

@available(iOS 10.0, *)
class MapViewController: BaseViewController {
  
  //MARK: - Properties
  var locationManager: CLLocationManager?
  var lastLocation: CLLocation?
  
  //MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var findMeButton: UIButton!
  @IBOutlet weak var saveAddressButton: UIButton!
  @IBOutlet weak var homeIcon: UIImageView!
  @IBOutlet weak var locationImageView: UIImageView!
  @IBOutlet weak var addressHolderView: UIView!
  @IBOutlet weak var mainActionHolderVIew: UIView!
  
  @IBOutlet weak var targetImageView: UIImageView!
  @IBOutlet weak var addressLabel: UITextField!
  @IBOutlet weak var floorNumberLabel: UITextField!
  @IBOutlet weak var aptNumLabel: UITextField!
  
  var contactVC: ContactViewController?
  var addressbookVC: AddressbookViewController?
  var address = Address(context: AppDelegate.MOC())
  var unsentDatapoints : [NSDictionary] = []
  
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !initialDesignApplied {
      initialDesignApplied = true
      initDesign()
      DataCollector.startDataCollection()
      
    }
  }
  @IBAction func calibratePressed(sender: AnyObject) {
    DataCollector.setBaseAltitude()
  }
  
  @IBAction func savedAddessessPressed(sender: AnyObject) {
    showAddressbook()
  }
  
  @IBAction func mapTapped(sender: AnyObject) {
    view.endEditing(true)
  }
  
  @IBAction func saveAddressPressed(sender: UIButton) {
    showSaveAddressVC()
  }
  
  @IBAction func contactPressed(sender: AnyObject) {
    showContactVC()
  }
  
  //MARK: - Actions
  @IBAction func findMePressed(sender: UIButton) {
    locateUserOnMap()
  }
}
