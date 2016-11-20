//
//  Compass.swift
//
//  Created by William Falcon on 8/20/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import CoreLocation

class Compass: NSObject {
    
    //MARK: - Properties
    static let sharedInstance = Compass()
    var locationManager: CLLocationManager!
    var locationUpdateBlock : ((_ location: CLLocation)->())?
    var visitUpdateBlock : ((_ visit: CLVisit)->())?
    var lastLocation : CLLocation?
    var lastVisit : CLVisit?
    
    //MARK: - Init helpers
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
}
