//
//  SecondViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let initialLocation = CLLocation(latitude: 59.3501, longitude: 18.0094)
        let initialLocation = CLLocation(latitude: 59.350924, longitude: 18.003663)
        centerMapOnLocation(location: initialLocation)
        
        postOfficesMapView.delegate = self
        
        postmanApi.getLocations(completionHandler: success)
        
        let annotation = MKPointAnnotation()
        
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 59.350924, longitude: 18.003663)
        postOfficesMapView.addAnnotation(annotation)
    }
    
    func success(err: Error?, locations: [Location]?, response: URLResponse?) -> Void {
        for place in locations! {
            print(place.lat)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(place.long), longitude: CLLocationDegrees(place.lat))
            postOfficesMapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var postOfficesMapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        postOfficesMapView.setRegion(coordinateRegion, animated: true)
    }

}

