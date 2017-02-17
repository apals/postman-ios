//
//  AskTableViewController.swift
//  Postman
//
//  Created by Axel Riese on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import MapKit
import UIKit

class AskTableViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    
    let newPin = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    
    var name : String? = nil
    var phone : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneLabel.text = phone
        nameLabel.text = name
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        
//        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
//        
//        longPressRecognizer.minimumPressDuration = 1.0
//        self.map.addGestureRecognizer(longPressRecognizer)
        //        self.map.zoomToUserLocation()
    }
    
    func handleLongPress(gestureRecognizer : UIGestureRecognizer){
        print("aaa")
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        self.map.addAnnotation(annotation)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print("CLICKED")
        postmanApi.postRequest()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        map.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        map.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        map.addAnnotation(newPin)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
