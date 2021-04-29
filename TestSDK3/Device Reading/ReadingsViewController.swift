//
//  ReadingsViewController.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2020-07-02.
//  Copyright © 2020 Daniel Karoumi. All rights reserved.
//

import Foundation
import KetoMojoSDK
//import PopupDialog
import JGProgressHUD

protocol DeviceReadingsDataSource: AnyObject {
    var deviceReadings: [BloodMeterRecord] { get }
    func numberOfReadings() -> Int
    func setupCell(_ cell: ReadingsTableView, at indexPath: IndexPath)
}


class ReadingsViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var device: BloodMeterDevice?
    private let deviceManager = DeviceManager.shared
    private var hud: JGProgressHUD?
    private var historyData = [BloodMeterRecord]()
    weak var dataSource: DeviceReadingsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDevice()
        device?.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

       }
    
    func getDevice(){
        guard
            deviceManager.connectedDevices.count==1
        else {
            print("ERROR")
            //presentPopup(title: "Error!", message: "Could'nt find device\nTry syncing")
            return
        }
        try! device = (deviceManager.connectedDevices[0] as! BloodMeterDevice)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone=TimeZone.current
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let indexPath = IndexPath(row: 0, section: 0)
        let data = historyData[indexPath.row]
        let datetime = dateFormatter.string(from: data.date)
        
        print(String(data.value.value) + " mmol/L")
        
        var response = dosomething()
        response.changeResult(data.value.value)
        response.changeResultTime(datetime)
        response.changePhenomenonTime(datetime)
        print(response)
        send(response)
    
        
        
        
        
        
        
        
//        Kod för att skicka värden till server:
      //  for var row in 0...3{
//            let indexPath = IndexPath(row: 0, section: 0)
//            let cell = tableView.cellForRow(at: indexPath) as! ReadingsTableView
//            let data = historyData[indexPath.row]
//            let url = URL(string: "https://picaso.eu/pd/pds/observation/homemeasurement/IHEPCD01/CommunicatePcdData")!
//            var request = URLRequest(url: url)
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            let parameters: [String: Any] = [
//                "Readings": data.value.value,
//                "name": data.date
//            ]
//            //request.httpBody = parameters.percentEncoded()
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data,
//                    let response = response as? HTTPURLResponse,
//                    error == nil else {                                              // check for fundamental networking error
//                    print("error", error ?? "Unknown error")
//                    return
//                }
//
//                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                    print("statusCode should be 2xx, but is \(response.statusCode)")
//                    print("response = \(response)")
//                    return
//                }
//
//                let responseString = String(data: data, encoding: .utf8)
//                print("responseString = \(responseString)")
//            }
//
//            task.resume()
       // }
    }
    
    @IBAction func getTest(_ sender: Any) {
        //Välj här vilken information som ska tas fram
        //getSerialNumber()
        let readings = device?.readRecords(includeQualityControl: false)
    }


    func getSerialNumber() {
        device?.readSerialNumber()
    }
}


extension ReadingsViewController: BloodMeterDeviceDelegate {
    func bloodMeter(_ device: BloodMeterDevice, didReadSerialNumber serialNumber: String) {
        //presentPopup(title: "Serial Number", message: serialNumber)
        print("SERIAL NUMBER?")
    }

    func bloodMeter(_ device: BloodMeterDevice, didReadUnit unit: BloodMeterUnit, description: String) {
        print("unit: ",description)
        
    }

    func bloodMeter(_ device: BloodMeterDevice, didReadHistoryData historyData: [BloodMeterRecord]) {
        hud?.dismiss(animated: true)
        self.historyData = historyData
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        tableView.reloadData()
        for var row in 0...historyData.count-1{
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! ReadingsTableView
            cell.bloodPicture.isHidden=false
            cell.bloodPictureKetone.isHidden=true
            cell.dateLabel.isHidden=false
            cell.readingsLabel.isHidden=false
            cell.sendButton.isHidden=false
            cell.sentLabel.isHidden=true
            let data = historyData[indexPath.row]
            let readings = [data.date]
            if data.sample.description=="Ketone"{
                cell.bloodPictureKetone.isHidden=false
                cell.bloodPicture.isHidden=true
            }
            //cell.textLabel?.text = String(data.value.value) + " mmol/L"
            cell.dateLabel.text = dateFormatter.string(from: data.date)
            cell.readingsLabel.text = String(data.value.value) + " mmol/L"
            //cell.typeLabel.text = data.sample.description
        }

            //presentPopup(title: "Date", message: dateFormatter.string(from: data.date))
        
    }

    func bloodMeter(_ device: BloodMeterDevice, didProcessedCommand: Bool, with error: DeviceError) {
        hud?.dismiss(animated: true)
        guard error != .none else { return }

    }

    func bloodMeter(_ device: BloodMeterDevice, didReadDate date: Date) {
        hud?.dismiss(animated: true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        //presentPopup(title: "Device Date", message: dateFormatter.string(from: date))
    }

    func bloodMeter(_ device: BloodMeterDevice, progress: Double) {
        hud?.progress = Float(progress)
        hud?.detailTextLabel.text = "\(Int(progress * 100))% Complete"
    }

    func disconnected(bloodMeter: BloodMeterDevice) {
    }
}

private extension ReadingsViewController {
    
//    func presentPopup(title: String, message: String, completion: (() -> Void)? = nil) {
//        let popupDialog = PopupDialog(title: title, message: message)
//        popupDialog.addButton(PopupDialogButton(title: "Ok", action: nil))
//        present(popupDialog, animated: true, completion: completion)
//    }

//    func presentConfirmationPopup(title: String, message: String, acceptedHandler: @escaping () -> Void) {
//        let popupDialog = PopupDialog(title: title, message: message)
//        popupDialog.buttonAlignment = .horizontal
//        popupDialog.addButton(PopupDialogButton(title: "Cancel", action: nil))
//        popupDialog.addButton(PopupDialogButton(title: "Ok", action: acceptedHandler))
//        present(popupDialog, animated: true)
//    }
}

extension ReadingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // välj kommando för vad som ska hända då cell trycks på
        print(indexPath)
        
    }

}


extension ReadingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReadingsTableView

        cell.dateLabel.isHidden=true
        cell.readingsLabel.isHidden=true
        cell.bloodPicture.isHidden=true
        cell.bloodPictureKetone.isHidden=true
        cell.sendButton.isHidden=true
        cell.sentLabel.isHidden=true
        return cell

    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
