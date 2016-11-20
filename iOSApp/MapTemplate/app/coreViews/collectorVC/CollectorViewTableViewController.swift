//
//  CollectorViewTableViewController.swift
//  911
//
//  Created by William Falcon on 8/28/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class CollectorViewTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var data : [Session] = []
    var mailVC: MFMailComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue._dispatchToBackgroundQueueWithPriority(0) {
            
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
            do {
                let results = try AppDelegate.MOC().fetch(req)
                self.data = results as! [Session]
                
                DispatchQueue._dispatchMainQueue({
                    self.tableView.reloadData()
                })
            }catch {
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        let session = data[indexPath.row]
        
        cell.textLabel?.text = subtitleFromSession(session: session)
        cell.detailTextLabel?.text = "Session: \(session.id!)"
        
        return cell
    }
    
    func subtitleFromSession(session: Session) -> String {
        var subTitle = ""
        if let city = session.cityName {
            subTitle += city + ", "
        }
        
        if let country = session.countryName {
            subTitle += country + " - "
        }
        
        if let envContext = session.envContext {
            subTitle += envContext
        }
        
        return subTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let session = data[indexPath.row]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let email = UIAlertAction(title: "Email Data", style: .default) { (action) in
            self.emailData(session: session)
        }
        let plot = UIAlertAction(title: "Plot", style: .default) { (action) in
            self.plotData(session: session)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
        }
        
        alert.addAction(email)
        alert.addAction(plot)
        alert.addAction(cancel)
        self.present(alert, animated: true) {
            
        }
    }
    
    func plotData(session: Session) {
        let vc = PlotViewController._newInstanceFromStoryboardNamed(sbName: "Collector") as! PlotViewController
        vc.session = session
        self.present(vc, animated: true, completion: nil)
    }
    
    func emailData(session: Session) {
        mailVC = MFMailComposeViewController()
        mailVC?.mailComposeDelegate = self
        mailVC?.setSubject("Sensory logs: \(subtitleFromSession(session: session)) - \(session.id!)")
        
        //attachment
        let csvData = session.data!.data(using: String.Encoding.utf8, allowLossyConversion: false)
        mailVC?.addAttachmentData(csvData!, mimeType: "text/csv", fileName: "\(session.id!).csv")
        present(mailVC!, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        mailVC?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let session = self.data[indexPath.row]
            self.data.remove(at: indexPath.row)
            AppDelegate.MOC().delete(session)
            do {
                try AppDelegate.MOC().save()
                self.tableView.reloadData()
                
            }catch {
                print(error)
            }
        }
    }
    
}
