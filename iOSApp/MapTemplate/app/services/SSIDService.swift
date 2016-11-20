//
//  SSIDService.swift
//  911
//
//  Created by William Falcon on 11/20/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

public class SSID {
    class func fetchSSIDInfo() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                print(interfaceName)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    //currentSSID = interfaceData["SSID"] as! String
                }
            }
        }
        return currentSSID
    }
}
