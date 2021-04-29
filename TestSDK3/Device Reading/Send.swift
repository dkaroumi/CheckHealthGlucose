//
//  Send.swift
//  Simpleupload
//
//  Created by Oscar Luong on 2021-04-08.
//

import Foundation

func send(_ res: Response){
    
    
    let session = URLSession.shared
    let url = URL(string: "https://picasogost.cnet.se/gost/v1.0/Observations")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    
    request.setValue("Basic cGljYXNvY2xpZW50OmFkOTNiemszeXZiZWszMGhhY285Mnk0dnNrNzZ3bmZsaGY5MXp4MDM3Zm5kdXl1", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    /*let urlen = Bundle.main.url(forResource: "location", withExtension: "json")!
    let dataa = try! Data(contentsOf: urlen)
    let response = try! JSONDecoder().decode(Response.self, from: dataa)*/
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    let orderJsonData = try! encoder.encode(res)
    //print(String(data: orderJsonData, encoding: .utf8)!)
    request.httpBody = orderJsonData
    
    session.dataTask(with: request, completionHandler: { data, response, error in
        print(String(data: data!, encoding: .utf8)!)
        print(response!)
        if((error) != nil){
            print(error!)
        }
    }).resume()
    
}
