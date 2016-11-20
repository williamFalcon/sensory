//
//  ContactVC+MessageUI.swift
//  911
//
//  Created by William Falcon on 8/22/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import Foundation
import MessageUI

extension ContactViewController: MFMessageComposeViewControllerDelegate {
  
  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    switch result.rawValue {
    case MessageComposeResult.cancelled.rawValue :
      print("message canceled")
      
    case MessageComposeResult.failed.rawValue :
      print("message failed")
      
    case MessageComposeResult.sent.rawValue :
      print("message sent")
      
    default:
      break
    }
    controller.dismiss(animated: true, completion: nil)
  }
  
  func sendMessage() {
    syncAddress()
    
    let messageVC = MFMessageComposeViewController()
    messageVC.body = "Emergency at:\n\(address!.description)"
    messageVC.recipients = ["911"] // Optionally add some tel numbers
    messageVC.messageComposeDelegate = self
    // Open the SMS View controller
    present(messageVC, animated: true, completion: nil)
  }
}
