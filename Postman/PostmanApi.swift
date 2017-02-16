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

public struct Coordinates {
    public let long: Float
    public let lat: Float
}

extension Coordinates {
    init?(json: [String:Any]) {
        let long = json["long"] as! Float
        let lat = json["lat"] as! Float
        
        self.long = long
        self.lat = lat
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
    
    
    func login(email: String, password: String, completionHandler:@escaping (Bool) -> ()) {
        
        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/me?email=\(email)&password=\(password)")!)
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            
            if err != nil {
                completionHandler(false)
                return
            }
            
            print(response)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
            
            }.resume()
        
    }
    
    func getLocations(completionHandler:@escaping (Error?, [Location]?, URLResponse?) -> ()) {
        let request = URLRequest(url: URL(string: "http://localhost:8000/locations.json")!)
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            
            if let err = err {
                completionHandler(err, nil, nil)
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                var locations: [Location] = []
                
                for locationJson in parsedData {
                    let p: Location = self.createLocationFromJson(locationJson)!
                    locations.append(p)
                }
                
                completionHandler(nil, locations, response)
                
            } catch let error as NSError {
                print(error)
            }
            }.resume()
    }
    
    func createLocationFromJson(_ locationJson: [String: Any]) -> Location? {
        return Location(json: locationJson)
    }
    
    
}


let postmanApi = PostmanApi()
