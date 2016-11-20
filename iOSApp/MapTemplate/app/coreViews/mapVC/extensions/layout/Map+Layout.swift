//
//  Map+Layout.swift
//  MapTemplate
//
//  Created by William Falcon on 8/18/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit

extension MapViewController {
  
  func initDesign() {
    designFindMeButton()
    locateUserOnMap()
    locationImageView._tintWithColor(color: UIColor.blue)
    addShadowToView(addressHolderView)
    addShadowToView(mainActionHolderVIew)
    targetImageView._tintWithColor(color: UIColor.red)
  }
  
  func addShadowToView(_ view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 1.0
    view.layer.shadowOpacity = 0.5
  }
  
  func designFindMeButton() {
    let btn = self.findMeButton
    btn?.layer.cornerRadius = (btn?.bounds.width)! / 2.0
    addShadowToView(btn!)

  }
}
