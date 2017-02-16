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
    public let id: String
    public let title: String?
    public let coordinate: CLLocationCoordinate2D
    
    init?(json: [String:Any]) {
        let id = json["id"] as! String
        let name = json["name"] as! String
        let coordinates = Coordinates(json: json["coordinates"] as! [String:Any])
        
        self.id = id
        self.title = name
        self.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees((coordinates?.long)!),
            longitude: CLLocationDegrees((coordinates?.lat)!))
        
        super.init()
    }
    
}
