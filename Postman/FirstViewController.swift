//
//  FirstViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postmanApi.getParcels(completionHandler: success)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func success(err: Error?, parcels: [Parcel]?, response: URLResponse?) -> Void {
        
        print(parcels)
         
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

