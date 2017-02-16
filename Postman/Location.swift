//
//  Location.swift
//  Postman
//
//  Created by Robin Hellgren on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import Foundation

import MapKit

class Location: NSObject, MKAnnotation {
    public let id: Int
    public let title: String?
    public let coordinate: CLLocationCoordinate2D
    public let distance: Float
    
    init?(json: [String:Any]) {
        let id = json["id"] as! Int
        let name = json["name"] as! String
        let distance = json["distance"] as! Float
        
        self.id = id
        self.title = name
        self.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(Float(json["longitude"] as! String)!),
            longitude: CLLocationDegrees(Float(json["latitude"] as! String)!))
                
        self.distance = distance
        
        super.init()
    }
    
}
