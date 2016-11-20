//
//  NSObject.swift
//  911
//
//  Created by William Falcon on 11/17/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation

extension NSObject {
    var _className: String {
        return String(describing: type(of: self))
    }
    
    class var _className: String {
        return String(describing: self)
    }
}
