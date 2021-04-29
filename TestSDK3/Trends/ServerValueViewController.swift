//
//  File.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2020-07-10.
//  Copyright © 2020 Daniel Karoumi. All rights reserved.
//
// This is a finished class

import Foundation
import UIKit
import KetoMojoSDK
//import PopupDialog

class ServerValueViewController: UIViewController{
    private var device: BloodMeterDevice?
    private let deviceManager = DeviceManager.shared
    private var historyData = [BloodMeterRecord]()
    weak var dataSource: DeviceReadingsDataSource?
    @IBOutlet weak var meanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDevice()
        device?.delegate = self
       }
    
    func getDevice(){
           guard
               deviceManager.connectedDevices.count==1
           else {
               print("ERROR")
               return
           }
           try! device = (deviceManager.connectedDevices[0] as! BloodMeterDevice)
       }
    
    @IBAction func getMean(_ sender: Any) {
            let readings = device?.readRecords(includeQualityControl: false)
        }
    
    func getSerialNumber() {
        device?.readSerialNumber()
        
    }
}


extension ServerValueViewController: BloodMeterDeviceDelegate {
    func bloodMeter(_ device: BloodMeterDevice, didReadSerialNumber serialNumber: String) {
//        hud?.dismiss(animated: true)
//        presentPopup(title: "Serial Number", message: serialNumber)
        print(serialNumber)
        
    }

    func bloodMeter(_ device: BloodMeterDevice, didReadUnit unit: BloodMeterUnit, description: String) {
//        hud?.dismiss(animated: true)
//        presentPopup(title: "Device Unit", message: description)
    }

    func bloodMeter(_ device: BloodMeterDevice, didReadHistoryData historyData: [BloodMeterRecord]) {
        var mean = 0.0
        var sum = 0.0
        for var row in 0...historyData.count-1{
            print("row: ",row)
            print("history.count: ", historyData.count)
            let indexPath = IndexPath(row: row, section: 0)
            let data=historyData[indexPath.row]
            print(data.value.value)
            sum += data.value.value
            
        }
        var doubleCount = Double(historyData.count)
        meanLabel.text = String(sum/doubleCount)

//        hud?.dismiss(animated: true)
//        self.historyData = historyData
//        performSegue(withIdentifier: "showReadings", sender: self)
    }

    func bloodMeter(_ device: BloodMeterDevice, didProcessedCommand: Bool, with error: DeviceError) {
//        hud?.dismiss(animated: true)
//        guard error != .none else { return }
//        presentPopup(title: "Error", message: error.localizedDescription)
    }

    func bloodMeter(_ device: BloodMeterDevice, didReadDate date: Date) {
//        hud?.dismiss(animated: true)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .short
//        dateFormatter.doesRelativeDateFormatting = true
//
//        presentPopup(title: "Device Date", message: dateFormatter.string(from: date))
    }

    func bloodMeter(_ device: BloodMeterDevice, progress: Double) {
//        hud?.progress = Float(progress)
//        hud?.detailTextLabel.text = "\(Int(progress * 100))% Complete"
    }

    func disconnected(bloodMeter: BloodMeterDevice) {
    //    presentPopup(title: "Connection lost", message: "Device was disconnected. Please turn it on again.")
    }
}
