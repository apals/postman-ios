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
    var requests: [Request] = []
    
    
    
    var refresherControl = UIRefreshControl()

    
    func handleRefresh(_ sender: AnyObject) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        getTheThings()
        
        self.tableView.reloadData()
        self.refresherControl.endRefreshing()
    }
    
    func getTheThings() {
        
        parcels = []
        requests = []
        postmanApi.getParcels(completionHandler: success)
        postmanApi.getRequests(completionHandler: successRequests)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.refresherControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refresherControl.addTarget(self, action: "handleRefresh:", for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refresherControl)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTheThings()
    }
    
    func reload() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    func success(err: Error?, parcels: [Parcel]?, response: URLResponse?) -> Void {
        self.parcels += parcels!
        reload()
    }
    
    func successRequests(err: Error?, r: [Request]?, response: URLResponse?) -> Void {
        for a in r! {
            //            if !a.accepted {
            requests.append(a)
            //            }
        }
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return "Your missions"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return parcels.count
        } else {
            return requests.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellIdentifier = "ParcelTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ParcelTableViewCell
            let parcel = parcels[indexPath.row]
            
            cell.senderLabel.text = parcel.sender
            cell.locationLabel.text = parcel.servicePoint
            return cell
        } else {
            let cellIdentifier = "MissionTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MissionTableViewCell
            let request = requests[indexPath.row]
            
            if request.accepted {
                cell.missionTitleLabel.textColor = UIColor.green
            } else {
                cell.missionTitleLabel.textColor = UIColor.red
            }
            cell.missionTitleLabel.text = request.servicePoint
            return cell
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let selectedRequestCell = sender as? MissionTableViewCell {
            let requestDetailViewController = segue.destination as! RequestDetailTableViewController
            let indexPath = tableView.indexPath(for: selectedRequestCell)!
            let request = requests[indexPath.row]
            requestDetailViewController.request = request
            requestDetailViewController.shouldShowButton = false
            
            if !request.accepted {
                requestDetailViewController.acceptable = true
            }
        }
        
        // Get the cell that generated this segue.
        if let selectedParselCell = sender as? ParcelTableViewCell {
            let parcelDetailViewController = segue.destination as! ParcelDetailTableViewController
            let indexPath = tableView.indexPath(for: selectedParselCell)!
            let selectedParsel = parcels[indexPath.row]
            parcelDetailViewController.parcel = selectedParsel
        }
    }
}




