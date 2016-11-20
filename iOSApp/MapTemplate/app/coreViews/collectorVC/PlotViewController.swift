//
//  PlotViewController.swift
//  911
//
//  Created by William Falcon on 9/13/16.
//  Copyright © 2016 William Falcon. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SVProgressHUD
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PlotViewController: UIViewController {
  
  @IBOutlet weak var indoorAccuracyLabel: UILabel!
  @IBOutlet weak var chartView: ScatterChartView!
  
  var session : Session?
  var oldData : [[String: AnyObject]] = []
  var data : [[String: AnyObject]] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    parseSession(session!)
    
    
    SVProgressHUD.show(withStatus: "Predicting...")
    fetchDataPredictions({ (data) in
      SVProgressHUD.dismiss()
      self.oldData = self.data
      self.data = data
      self.drawData()
      self.evaluateIndoorAccuracy()
      
    }) { (error) in
      SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
  }
  
  func evaluateIndoorAccuracy() {
    var correct = 0
    var seen = 0
    for (old, newDp) in zip(self.oldData, self.data) {
      let oldIndoors = old["indoors"] as! Int
      let newIndoors = newDp["indoors_prediction"] as! Int
      if oldIndoors != -1 {
        seen += 1
        correct += oldIndoors == newIndoors ? 1 : 0
      }
    }
    
    self.indoorAccuracyLabel.text = "IO Classifier accuracy: \(100*(Double(correct) / Double(seen)))%"
  }
  
  func drawData() {
    //generate x
    var x : [String] = []
    for dic in data {
      
      let dateStr = dic["created_at"]! as! String
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
      dateFormatter.timeZone = TimeZone(identifier: "EST")

      var date = dateFormatter.date(from: dateStr)
      date = date?._addMilliseconds(ms: -3600)
      
      let str = date?._dateString(format: "hh:mm:ss")
      x.append(str!)
    }
    
    var y : [Double] = []
    for dic in data {
      let pressure = dic["alt_pressure"]! as! Double
      y.append(pressure)
    }
    
    
    DispatchQueue._dispatchMainQueue {
      self.setChart(x, values: y, data:self.data)
    }
  }
  
  func parseSession(_ session:Session) {
    //get cols
    let rows = session.data?._splitOn("\n")
    let cols = rows![0]._splitOn(",")
    
    //results
    var dps : [[String: AnyObject]] = []
    if rows?.count > 1 {
      
      //parse each row
      for row in rows![1...rows!.count-1] {
        let vals = row._splitOn(",")
        if vals.count > 1 {
          //parse 1 datapoint
          var dp : [String: AnyObject] = [:]
          for (col, val) in zip(cols, vals) {
            
            switch col {
            case "baro_relative_altitude":
              dp["alt"] = Double(val)! as AnyObject?
              
            case "baro_pressure":
              dp["alt_pressure"] = Double(val)! as AnyObject?
              
            case "gps_latitude":
              dp["latitude"] = Double(val)! as AnyObject?
              
            case "gps_longitude":
              dp["longitude"] = Double(val)! as AnyObject?
              
            case "gps_longitude":
              dp["gps_alt"] = Double(val)! as AnyObject?
              
            case "created_at":
              dp[col] = val as AnyObject?
              
            case "gps_vertical_accuracy", "gps_horizontal_accuracy", "gps_speed", "gps_course", "indoors":
              dp[col] = Double(val)! as AnyObject?
              
            default:
              continue
            }
          }
          
          //track dp
          if dp.count > 4 {
            dp["device_id"] = UIDevice.current.identifierForVendor!.uuidString as AnyObject?
            
            dp["gps_alt"] = -1 as AnyObject?
            dp["gps_course"] = -1 as AnyObject?
            dps.append(dp)
          }
        }
      }
    }
    self.data = dps
  }
  
  
  func setChart(_ dataPoints: [String?], values: [Double], data: [[String: AnyObject]]) {
    
    var outdoorPoints: [ChartDataEntry] = []
    var indoorPoints: [ChartDataEntry] = []
    
    //split bn indoors and outdoor points
    for i in 0..<dataPoints.count {
      let dp = data[i]
      if let indoors = dp["indoors_prediction"] as? Bool {
        let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
        if indoors {
          indoorPoints.append(dataEntry)
        }else {
          outdoorPoints.append(dataEntry)
        }
      }
    }
    
    let size: CGFloat = 4.0
    //Y
    let indoorsY = ScatterChartDataSet(values: indoorPoints, label: "Indoors")
    indoorsY.setColor(UIColor.red)
    indoorsY.scatterShapeSize = size
    indoorsY.setScatterShape(.circle)

    
    let outdoorsY = ScatterChartDataSet(values: outdoorPoints, label: "Outdoors")
    outdoorsY.scatterShapeSize = size
    outdoorsY.setScatterShape(.circle)
    
    //X
    let chartData = ScatterChartData(dataSets: [indoorsY, outdoorsY])//ScatterChartData(xVals: dataPoints, dataSets: )
    
    //plot
    chartView.data = chartData
    chartView.descriptionText = "Prediction results"
    
  }
  
  func fetchDataPredictions(_ onSuccess:((_ data: [[String: AnyObject]]) -> ())? = nil, onFailure:((_ error: NSError)->())? = nil) {
    //clear the dataQ in preparation for uploading
    
    let url = "\(AppSettings.API_ROOT())/test"
    let headers = ["Content-Type": "application/json"]
    Alamofire.request(url, method: .post, parameters: ["data": self.data], encoding: JSONEncoding.default, headers: headers)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          if let json = response.result.value as? [[String : AnyObject]] {
            let data = json
            onSuccess?(data)
          }
        //onSuccess?()
        case .failure(let error):
          print(error)
          print(error.localizedDescription)
          onFailure?(error as NSError)
        }
    }
  }
  
  
  @IBAction func donePressed(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
