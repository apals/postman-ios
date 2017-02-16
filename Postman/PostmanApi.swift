//
//  PostmanApi.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import Foundation

public struct Courier {
    public let name: String
    public let id: String
}

extension Courier {
    init?(json: [String:Any]) {
        let name = json["name"] as! String
        let id = json["id"] as! String
        
        self.name = name
        self.id = id
    }
}

public struct Status {
    public let message: String
    public let pickedUp: Bool
    public let courier: Courier?
    public let delivered: Bool
}

extension Status {
    init?(json: [String:Any]) {
        let message = json["message"] as! String
        let pickedUp = json["pickedUp"] as! Bool
        let delivered = json["delivered"] as! Bool
        let courierJson = json["courier"]
        if courierJson is NSNull  {
            self.courier = nil
        } else {
            self.courier = Courier(json: courierJson as! [String:Any])
        }
        
        self.delivered = delivered
        self.message = message
        self.pickedUp = pickedUp
    }
}

public struct Parcel {
    public let id: String
    public let status: Status
    public let sender: String
    public let location: String
}

extension Parcel {
    init?(json: [String:Any]) {
        let id = json["id"] as! String
        let status = Status(json: json["status"] as! [String:Any])
        let sender = json["sender"] as! String
        let location = json["location"] as! String
        
        self.id = id
        self.status = status!
        self.sender = sender
        self.location = location
    }
}

open class PostmanApi {
    
    func getParcels(completionHandler:@escaping (Error?, [Parcel]?, URLResponse?) -> ()) {
        let request = URLRequest(url: URL(string: "http://localhost:8000/parcels.json")!)
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            
            if let err = err {
                completionHandler(err, nil, nil)
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                var parcels: [Parcel] = []
                
                for parcelJson in parsedData {
                    let p: Parcel = self.createParcelFromJson(parcelJson)!
                    parcels.append(p)
                }
                
                completionHandler(nil, parcels, response)
                
            } catch let error as NSError {
                print(error)
            }
            }.resume()
    }
    
    func createParcelFromJson(_ parcelJson: [String: Any]) -> Parcel? {
        return Parcel(json: parcelJson)
    }
    
}


let postmanApi = PostmanApi()
