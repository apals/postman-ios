//
//  PostmanApi.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import Foundation

public struct Courier {
    public var name: String?
    public var id: String?
}

public struct Status {
    public var message: String?
    public var pickedUp: Bool?
    public var courier: Courier?
}

public struct Parcel {
    public var id: String?
    public var status: Status?
    public var sender: String?
    public var location: String?
    public var delivered: Bool?
}


open class PostmanApi {
    
    func getParcels(completionHandler:@escaping (Error?, [Parcel]?, URLResponse?) -> ()) {
        let request = URLRequest(url: URL(string: "https://medconf.apals.se/api/events")!)
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
                    let p: Parcel = self.createParcelFromJson(parcelJson)
                    parcels.append(p)
                }
                
                completionHandler(nil, parcels, response)
                
            } catch let error as NSError {
                print(error)
            }
            }.resume()
    }
    
    func createParcelFromJson(_ parcelJson: [String: Any]) -> Parcel {
        var p: Parcel = Parcel()
        
        p.id = parcelJson["id"] as? String
        p.status = self.createStatusFromJson(parcelJson["status"])
        p.sender = parcelJson["sender"] as? String
        p.location = parcelJson["location"] as? String
        p.delivered = parcelJson["delivered"] as? Bool
        
        return p
    }
    
    func createStatusFromJson(_ json: Any?) -> Status{
        let jsonDict = json as! [String: Any]
        var s: Status = Status()
        s.message = jsonDict["message"] as? String
        s.pickedUp =  jsonDict["pickedUp"] as? Bool
        s.courier = self.createCourierFromJson(jsonDict["courier"])
        return s
    }
    
    func createCourierFromJson(_ json: Any?) -> Courier {
        var c: Courier = Courier()
        return c
    }
    
}


let postmanApi = PostmanApi()
