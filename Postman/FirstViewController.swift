//
//  FirstViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {
    
    var parcels: [Parcel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postmanApi.getParcels(completionHandler: success)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func success(err: Error?, parcels: [Parcel]?, response: URLResponse?) -> Void {
        print(parcels)
        self.parcels += parcels!
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ParcelTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ParcelTableViewCell
        let parcel = parcels[indexPath.row]
        
        cell.senderLabel.text = parcel.sender
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}




