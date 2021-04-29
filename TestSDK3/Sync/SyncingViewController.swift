//
//  ViewController.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2020-06-23.
//  Copyright © 2020 Daniel Karoumi. All rights reserved.
//

import UIKit
import CoreBluetooth
import KetoMojoSDK
import Foundation
//import BlueSwift
//import PopupDialog


class SyncingViewController: UIViewController {
    var centralManager: CBCentralManager!
    private var discoveredDevices = [DiscoveredDevice]()
    private var devices = [Device]()
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var searchingLabel: UILabel!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var foundImage: UIImageView!
    @IBOutlet weak var searchingImage: UIImageView!
    @IBOutlet weak var connectedToLabel: UILabel!
    
        
    private lazy var deviceManager: DeviceSynchronizable = {
        let deviceManager = DeviceManager.shared
        deviceManager.delegate = self as? DeviceManagerDelegate
        return deviceManager
    }()
    
    private var connectedDevice: BloodMeterDevice? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.deviceNameLabel.text = self?.connectedDevice?.name ?? ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchingImage.isHidden=false
        foundImage.isHidden=true
        foundLabel.isHidden=true
        connectedToLabel.isHidden=true
        centralManager = CBCentralManager(delegate: self, queue: nil)
        deviceManager.startScan()
        // Do any additional setup after loading the view.
    }
    
    
    func connect(){
        guard
            discoveredDevices.indices.contains(0)
        else {
            //presentPopup(title: "Error!", message: "Could'nt find device\nTry turning it on")
            print("DJKHAS")
            return
        }
        try! deviceManager.connect(with: discoveredDevices[0])
        centralManager.stopScan()
        searchingImage.isHidden=true
        foundImage.isHidden=false
        searchingLabel.isHidden=true
        foundLabel.isHidden=false
        connectedToLabel.isHidden=false
    }
    

    
}


extension SyncingViewController: CBCentralManagerDelegate {
func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
        //presentPopup(title: "Error!", message: "Bluetooth is off")
      case .poweredOn:
        print("central.state is .poweredOn")
        
    }
}
}

extension SyncingViewController: DeviceManagerDelegate {
    func deviceManager(_ manager: DeviceManager, didDiscover device: DiscoveredDevice) {
        discoveredDevices.append(device)
        print(device.name!)
        connect()
    }

    func deviceManager(_ manager: DeviceManager, didDisappear device: DiscoveredDevice) {
        discoveredDevices.removeAll(where: { $0 === device })
    }

    func deviceManager(_ manager: DeviceManager, connectErrorOccured error: ConnectError) {
    }

    func connected(with bloodMeter: BloodMeterDevice) {
        connectedDevice = bloodMeter
    }
}

private extension SyncingViewController {
    
//    func presentPopup(title: String, message: String, completion: (() -> Void)? = nil) {
//        let popupDialog = PopupDialog(title: title, message: message)
//        popupDialog.addButton(PopupDialogButton(title: "Ok", action: nil))
//        present(popupDialog, animated: true, completion: completion)
//    }
//
//    func presentConfirmationPopup(title: String, message: String, acceptedHandler: @escaping () -> Void) {
//        let popupDialog = PopupDialog(title: title, message: message)
//        popupDialog.buttonAlignment = .horizontal
//        popupDialog.addButton(PopupDialogButton(title: "Cancel", action: nil))
//        popupDialog.addButton(PopupDialogButton(title: "Ok", action: acceptedHandler))
//        present(popupDialog, animated: true)
//    }
}
