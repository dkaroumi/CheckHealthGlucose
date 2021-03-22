//
//  ReadingsTableView.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2020-07-08.
//  Copyright © 2020 Daniel Karoumi. All rights reserved.
//

import UIKit
final class ReadingsTableView: UITableViewCell {


   // @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var readingsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bloodPicture: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var bloodPictureKetone: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBAction func sendPressed(_ sender: Any) {
        sendButton.isHidden=true
        sentLabel.isHidden=false
    }
}
