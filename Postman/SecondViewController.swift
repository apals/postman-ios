//
//  SecondViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate {

    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        postOfficesMapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 59.3501, longitude: 18.0094)
        centerMapOnLocation(location: initialLocation)
        
        postmanApi.getLocations(completionHandler: success)
    }
    
    func success(err: Error?, locations: [Location]?, response: URLResponse?) -> Void {
        for place in locations! {
            postOfficesMapView.addAnnotation(place)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinTintColor = .red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    
    var clickedLocation: Location?
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        clickedLocation = annotationView.annotation as! Location
        self.performSegue(withIdentifier: "ShowParcelsAtServicePoint", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let servicePointPackagesTableViewController = segue.destination as! ServicePointPackagesTableViewController
        servicePointPackagesTableViewController.location = clickedLocation
    }
}

