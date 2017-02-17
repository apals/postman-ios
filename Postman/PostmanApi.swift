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
        let pickedUp = json["picked_up"] as! Bool
        let delivered = json["delivered"] as! Bool
        let courierJson = json["courier"]
        if courierJson is NSNull || courierJson == nil {
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
    public let servicePoint: String
    //public let location: String
}

extension Parcel {
    init?(json: [String:Any]) {
        let id = json["id"] as! Int
        let status = Status(json: json["status"] as! [String:Any])
        let sender = json["sender"] as! String
        //        let location = json["location"] as! String
        self.servicePoint = json["service_point"] as! String
        
        self.id = id
        self.status = status!
        self.sender = sender
        //  self.location = location
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
        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/parcels?email=a@a.se&password=a")!)
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
    
    func getLocations(_ lat: Double, _ long: Double, completionHandler:@escaping (Error?, [Location]?, URLResponse?) -> ()) {
//        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/service_points?email=a@a.se&password=a&longitude=\(long)&latitude=\(lat)")!)
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

    
    
    let addresses = ["Alpvägen 23", "Ringgatan 11b", "Skolgatan 99", "Skogalund 15", "Rissnegatan 37"]
    var i = 0
    
    func postRequest(parcelId: Int, ownerId: Int, price: Int) {
        var request = URLRequest(url: URL(string: "http://postman.quemar.mx/requests?email=a@a.se&password=a")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dict = ["request": ["parcel_id": parcelId, "owner_id": ownerId, "price": price, "address": addresses[i % addresses.count]]] as [String: Any]

        
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        URLSession.shared.dataTask(with: request) {data, response, err in
            print(data)
            print(response)
            print(err)
            }.resume()
    }
    
    func updateRequest(requestId: Int, accepted: Bool) {
        
        var request = URLRequest(url: URL(string: "http://postman.quemar.mx/requests/\(requestId)?email=a@a.se&password=a")!)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dict = ["_method": "PATCH", "request": ["id": requestId, "accepted": accepted]] as [String: Any]
        
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        URLSession.shared.dataTask(with: request) {data, response, err in
            print(data)
            print(response)
            print(err)
            }.resume()
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
    
    
    
    
    
    func getRequests(completionHandler:@escaping (Error?, [Request]?, URLResponse?) -> ()) {
        let request = URLRequest(url: URL(string: "http://postman.quemar.mx/requests?email=a@a.se&password=a")!)
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
    public let id: Int
    public let servicePoint: String
    public let parcelWeight: Int
    public let parcelSize: String
    public let price: Int
    public let address: String
    public let accepted: Bool
    
    init?(json: [String:Any]) {
        self.id = json["id"] as! Int
        self.servicePoint = json["service_point"] as! String
        self.parcelWeight = json["parcel_weight"] as! Int
        self.parcelSize = json["parcel_size"] as! String
        self.price = json["price"] as! Int
        self.address = json["address"] as! String
        self.accepted = json["accepted"] as! Bool
    }
}


let postmanApi = PostmanApi()
