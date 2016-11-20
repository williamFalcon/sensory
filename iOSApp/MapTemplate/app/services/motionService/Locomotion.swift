//
//  Locomotion.swift
//  911
//
//  Created by William Falcon on 8/23/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import CoreMotion

//get history for last 24 hours
let MOTION_HISTORY_TIMEFRAME_FOR_TRAINING_MINUTES = 60 * 24;
let MOTION_HISTORY_TIMEFRAME_FOR_PREDICTION_MINUTES = 30;

class Locomotion: NSObject {
    
    static let sharedInstance = Locomotion()
    var motionManager: CMMotionManager?
    var altimeter: CMAltimeter?
    var onMotion: CMAccelerometerHandler?
    
    override fileprivate init() {
        super.init()
        motionManager = CMMotionManager()
        altimeter = CMAltimeter()
    }
    
    class func streamAccelerometerUpdates(_ onMotion: @escaping CMAccelerometerHandler) {
        let motionManager = Locomotion.sharedInstance.motionManager!
        motionManager.accelerometerUpdateInterval = 1.0
        motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: onMotion)
        //        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in
        //
        //            //turn into dict
        //            if let lastLoc = self.lastLocation {
        //                let datapoint = self.generateDatapointFromLocation(lastLoc)
        //
        //                //track json DP ONLY if have barometer pressure
        //                if let jsonDP = self.generateJSONDatapointForLocation(lastLoc) {
        //                    self.jsonDataPoints.addObject(jsonDP)
        //                    self.pointCountLabel.text = "DPs: \(self.jsonDataPoints.count)"
        //
        //                    if (self.jsonDataPoints.count % 5 == 0) {
        //                        //reload to show point
        //                        self.tableView.reloadData()
        //                    }
        //                }
        //
        //                //track last point for view
        //                self.dataPoints.addObject(datapoint)
        //
        //            }
        //        }
    }
    
    class func signalStrength() -> Double {
        let app = UIApplication.shared
        let bar = app.value(forKey: "statusBar")!
        let fv = (bar as AnyObject).value(forKey: "foregroundView") as! UIView
        let svs = fv.subviews
        for var view in svs {
            if view.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
                var strength = view.value(forKey: "signalStrengthRaw")! as! Double
                return strength
            }
            
        }
        return -1
    }
    
    class func streamBarometerData(_ onData: @escaping CMAltitudeHandler) {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            let altimeter = Locomotion.sharedInstance.altimeter!
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: onData)
            
        }
    }
    
    class func stopStreamBarometerData() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            let altimeter = Locomotion.sharedInstance.altimeter!
            altimeter.stopRelativeAltitudeUpdates()
            
        }
    }
}
