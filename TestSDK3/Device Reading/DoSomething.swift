//
//  DoSomething.swift
//  Simpleupload
//
//  Created by Oscar Luong on 2021-04-01.
//

import Foundation

func dosomething() -> Response{
    
    let sem = DispatchSemaphore(value: 0)
    let session = URLSession.shared
    let url = URL(string: "https://picasogost.cnet.se/gost/v1.0/Observations(212011)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    /*let session = URLSession.shared
    let url = URL(string: "https://picasogost.cnet.se/gost/v1.0/Observations")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"*/
    
    
    request.setValue("Basic cGljYXNvY2xpZW50OmFkOTNiemszeXZiZWszMGhhY285Mnk0dnNrNzZ3bmZsaGY5MXp4MDM3Zm5kdXl1", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    /*let urlen = Bundle.main.url(forResource: "location", withExtension: "json")!
    let dataa = try! Data(contentsOf: urlen)
    let response = try! JSONDecoder().decode(Response.self, from: dataa)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let orderJsonData = try! encoder.encode(response)
    var test = try! JSONDecoder().decode(Response.self, from:orderJsonData)*/
    //print(String(data: orderJsonData, encoding: .utf8)!)
    //request.httpBody = orderJsonData
    var test = Response()
    
    session.dataTask(with: request, completionHandler: { data, response, error in
        print(String(data: data!, encoding: .utf8)!)
        test = try! JSONDecoder().decode(Response.self, from: data!)
        //print(test)
        print(response!)
        if((error) != nil){
            print(error!)
        }
        sem.signal()
    }).resume()

    sem.wait()
    
    return test
}
