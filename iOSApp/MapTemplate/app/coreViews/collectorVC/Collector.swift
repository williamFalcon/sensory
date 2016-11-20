//
//  Collector.swift
//  911
//
//  Created by William Falcon on 8/27/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import CoreData

class Collector: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var rssiStrengthCell: UITableViewCell!
    @IBOutlet weak var cityNameCell: UITableViewCell!
    @IBOutlet weak var countryNameCell: UITableViewCell!
    @IBOutlet weak var gpsLatitudeCell: UITableViewCell!
    @IBOutlet weak var gpsLongitudeCell: UITableViewCell!
    @IBOutlet weak var gpsCourseCell: UITableViewCell!
    @IBOutlet weak var gpsSpeedCell: UITableViewCell!
    @IBOutlet weak var baroAltitudeCell: UITableViewCell!
    @IBOutlet weak var baroPressureCell: UITableViewCell!
    @IBOutlet weak var vertAccuracyCell: UITableViewCell!
    @IBOutlet weak var horAccuracyCell: UITableViewCell!
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var countryNameTextField: UITextField!
    
    
    @IBOutlet weak var datapointCountLabel: UILabel!
    @IBOutlet weak var envDescriptionTextField: UITextField!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var playButton: UIBarButtonItem!
    @IBOutlet weak var pauseButton: UIBarButtonItem!
    
    var dataPoints: [[String: AnyObject]] = []
    
    var envDescription: String = ""
    var indoorStatus: NSInteger = 0
    var envAvgFloors: String = "0-2"
    var activity: String = "walking"
    var locationManager: CLLocationManager?
    var sessionId: String = ""
    var baroRelativeAlt : Double = -1
    var baroRelativePressure: Double = -1
    
    
    var latitude: Double = -1
    var longitude: Double = -1
    var heading: Double = -1
    var speed: Double = -1
    var verticalAccuracy: Double = -1
    var horizontalAccuracy: Double = -1
    
    var timer: Timer?
    
    enum Indoors: Int {
        case indoors = 1
        case outdoors = 0
    }
    
    var avgFloors = ["0-2", "3-5", "6-10", "10-20", "20-50", "50+"]
    var activities = ["walking", "running", "biking", "subway", "driving", "boat", "plane"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        self.pauseButton.tintColor = UIColor.clear
        
        self.cityNameTextField.delegate = self
        self.countryNameTextField.delegate = self
        self.envDescriptionTextField.delegate = self
        SSID.fetchSSIDInfo()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 6
        case 3:
            return 2
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func indoorOutdoorToggle(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        indoorStatus = sender.selectedSegmentIndex
        if sender.selectedSegmentIndex == 2 {
            indoorStatus = -1
        }
    }
    
    @IBAction func bldgHeightToggled(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        envAvgFloors = avgFloors[sender.selectedSegmentIndex]
    }
    
    @IBAction func activityToggled(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        activity = activities[sender.selectedSegmentIndex]
    }
    
    
    func addDataPoint() {
        
        var dp: [String: AnyObject] = [
            "indoors": indoorStatus as AnyObject,
            "gps_latitude": latitude as AnyObject,
            "gps_longitude": longitude as AnyObject,
            "gps_vertical_accuracy": verticalAccuracy as AnyObject,
            "gps_horizontal_accuracy": horizontalAccuracy as AnyObject,
            "gps_course": heading as AnyObject
        ]
        dp["gps_speed"] = speed as AnyObject
        dp["baro_relative_altitude"] = baroRelativeAlt as AnyObject
        dp["baro_pressure"] = baroRelativePressure as AnyObject
        dp["env_context"] = envDescriptionTextField.text?.lowercased() as AnyObject? ?? "" as AnyObject?
        dp["env_mean_bldg_floors"] = envAvgFloors as AnyObject
        dp["env_activity"] = activity.lowercased() as AnyObject?
        dp["city_name"] = self.cityNameTextField.text?.lowercased() as AnyObject?? ?? "" as AnyObject?
        dp["country_name"] = self.countryNameTextField.text?.lowercased() as AnyObject?? ?? "" as AnyObject?
        dp["created_at"] = Date()._UTCTimestamp() as AnyObject?
        dp["session_id"] = sessionId as AnyObject?
        dp["rssi_strength"] = Locomotion.signalStrength() as AnyObject?
        
        self.updateCells(dp)
        self.dataPoints.append(dp)
        self.datapointCountLabel.text = "\(self.dataPoints.count)"
    }
    
    func updateCells(_ dp: [String: AnyObject]) {
        self.cityNameCell.detailTextLabel?.text = "\(dp["city_name"]!)"
        self.countryNameCell.detailTextLabel?.text = "\(dp["country_name"]!)"
        self.gpsLatitudeCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_latitude"] as! Double) as String
        self.gpsLongitudeCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_longitude"] as! Double) as String
        self.gpsCourseCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_course"] as! Double) as String
        self.gpsSpeedCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_speed"] as! Double) as String
        self.baroAltitudeCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["baro_relative_altitude"] as! Double) as String
        self.baroPressureCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["baro_pressure"] as! Double) as String
        self.vertAccuracyCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_vertical_accuracy"] as! Double) as String
        self.horAccuracyCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["gps_horizontal_accuracy"] as! Double) as String
        self.rssiStrengthCell.detailTextLabel?.text = NSString(format: "%0.04f", dp["rssi_strength"] as! Double) as String
    }
    
    @IBAction func playHit(_ sender: UIBarButtonItem) {
        //session id = starttime
        self.sessionId = Date()._UTCTimestamp()
        
        //save DP every n seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Collector.addDataPoint), userInfo: nil, repeats: true)
        
        self.pauseButton.tintColor = UIColor.red
        self.playButton.tintColor = UIColor.clear
        //start recording animation
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.recordingLabel.alpha = 1.0
            
        }, completion: { (ended) in
        })
        
        Locomotion.streamBarometerData { (data, error) in
            if let data = data {
                self.baroRelativeAlt = data.relativeAltitude.doubleValue
                self.baroRelativePressure = data.pressure.doubleValue
            }
        }
        
        //stream location data
        Compass.startMonitoringBackgroundLocation(kCLLocationAccuracyBest) { (location) in
            
            //update address info
            let updateAddress = self.longitude == -1
            
            self.longitude = location.coordinate.longitude
            self.latitude = location.coordinate.latitude
            self.speed = location.speed
            self.heading = location.course
            self.verticalAccuracy = location.verticalAccuracy
            self.horizontalAccuracy = location.horizontalAccuracy
            
            if updateAddress {
                Compass.addressFromLocation(location, completionClosure: { (addressDict) in
                    if let city = addressDict?["City"] as? String {
                        self.cityNameTextField.text = city
                    }
                    
                    if let country = addressDict?["Country"] as? String {
                        self.countryNameTextField.text = country
                    }
                    
                    if let name = addressDict?["Name"] as? String {
                        self.envDescriptionTextField.text = name
                    }
                })
            }
        }
        
    }
    
    @IBAction func pausePressed(_ sender: UIBarButtonItem) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.recordingLabel.alpha = 0.0
            self.pauseButton.tintColor = UIColor.clear
            self.playButton.tintColor = UIColor.blue
        })
        timer?.invalidate()
        Compass.stopMonitoringVisits()
        Locomotion.stopStreamBarometerData()
        
        
        let alert = UIAlertController(title: "Save Session?", message: "Session ID:\n\(self.sessionId)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "save", style: .default) { (alert) in
            //clear old session
            self.saveSession()
            self.clearSession()
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (alert) in
            //clear old session
            self.clearSession()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveSession() {
        let data = csvFromDatapoints()
        let entity = Session(context: AppDelegate.MOC())
        entity.id = sessionId
        entity.data = data
        
        entity.cityName = self.cityNameTextField.text
        entity.countryName = self.countryNameTextField.text
        entity.envContext = self.envDescriptionTextField.text
        
        do {
            try AppDelegate.MOC().save()
        }catch {
            print(error)
        }
    }
    
    func csvFromDatapoints() -> String {
        if self.dataPoints.count > 0 {
            let colNames = ["indoors","created_at","session_id", "rssi_strength", "gps_latitude", "gps_longitude","gps_vertical_accuracy","gps_horizontal_accuracy","gps_course","gps_speed","baro_relative_altitude","baro_pressure","env_context","env_mean_bldg_floors","env_activity","city_name","country_name"]
            let header = colNames.joined(separator: ",") + "\n"
            var data = header
            
            for var dp in self.dataPoints {
                var vals: [String] = []
                for var key in colNames {
                    vals.append("\(dp[key]!)")
                }
                let row = vals.joined(separator: ",") + "\n"
                data += row
            }
            
            return data
        }
        
        return ""
    }
    
    func clearSession() {
        self.dataPoints.removeAll()
        self.datapointCountLabel.text = "\(self.dataPoints.count)"
    }
    
    func initLocationManager() {
        if locationManager == nil {
            let mgr = CLLocationManager()
            
            
            //need best for indoors
            mgr.desiredAccuracy = kCLLocationAccuracyBest
            locationManager = mgr
        }
        
        
        //allow location updates even in background
        locationManager?.requestAlwaysAuthorization()
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
