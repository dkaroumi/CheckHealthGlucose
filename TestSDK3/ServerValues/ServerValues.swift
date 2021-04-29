//
//  ServerValues.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2021-04-16.
//  Copyright © 2021 Daniel Karoumi. All rights reserved.
//

import Foundation
import UIKit

class ServerValues: UIViewController{

    @IBOutlet weak var ServerValueLabel: UILabel!
    @IBOutlet weak var ServerTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       }
    @IBAction func getServerValuePressed(_ sender: Any) {
        var response = dosomething()
        print("\(response)" as String)
        print(response.result.component[0].valueQuantity.value)
        ServerValueLabel.text=String(response.result.component[0].valueQuantity.value) + " mmol/l"
        ServerTimeLabel.text=response.resultTime
    }
}
