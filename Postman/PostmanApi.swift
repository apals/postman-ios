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
    public let id: Int
}

extension Courier {
    init?(json: [String:Any]) {
        let name = json["name"] as! String
        let id = json["id"] as! Int
        
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
    public let id: Int
    public let status: Status
    public let sender: String
    public let location: String
}

extension Parcel {
    init?(json: [String:Any]) {
        let id = json["id"] as! Int
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
        let long = json["longitude"] as! Float
        let lat = json["latitude"] as! Float
        
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
        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/service_points?email=a@a.se&password=a&longitude=59.332484&latitude=18.061296")!)
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
    
    
    
    func getRequestsAtServicePoint(id: Int, completionHandler:@escaping (Error?, [Request]?, URLResponse?) -> ()) {
        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/requests?email=a@a.se&password=a&service_point_id=\(id)")!)
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            
            if let err = err {
                completionHandler(err, nil, nil)
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String: Any]]
                var requests: [Request] = []
                
                for requestJson in parsedData {
                    let r: Request = Request(json: requestJson)!
                    requests.append(r)
                }
                
                completionHandler(nil, requests, response)
                
            } catch let error as NSError {
                print(error)
            }
            }.resume()
    }
    
}

public struct Request {
    public let servicePoint: String
    public let parcelWeight: Int
    public let parcelSize: String
    public let price: Int
    public let address: String
    public let accepted: Bool
    
    init?(json: [String:Any]) {
        
        self.servicePoint = json["service_point"] as! String
        self.parcelWeight = json["parcel_weight"] as! Int
        self.parcelSize = json["parcel_size"] as! String
        self.price = json["price"] as! Int
        self.address = json["address"] as! String
        self.accepted = json["accepted"] as! Bool
    }
}


let postmanApi = PostmanApi()
