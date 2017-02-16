//
//  Location.swift
//  Postman
//
//  Created by Robin Hellgren on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import Foundation

import MapKit

public struct Location {
    public let id: String
    public let title: String?
    public let long: Float
    public let lat: Float
    
    init?(json: [String:Any]) {
        let id = json["id"] as! String
        let name = json["name"] as! String
        let long = (json["coordinates"] as! [String:Any])["long"] as! Float
        let lat = (json["coordinates"] as! [String:Any])["lat"] as! Float
        
        self.id = id
        self.title = name
        self.long = long
        self.lat = lat
    }
}
