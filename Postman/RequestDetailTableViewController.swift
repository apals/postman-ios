//
//  RequestDetailTableViewController.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit

class RequestDetailTableViewController: UITableViewController {
    
    var shouldShowButton: Bool = true
    var acceptable: Bool = false
    
    
    var request: Request?
    @IBOutlet weak var acceptButton: UIButton!

    @IBOutlet weak var weightAndSizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var servicePointLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let request = request {
            weightAndSizeLabel.text = String(request.parcelWeight) + "g, " + request.parcelSize
            priceLabel.text = String(request.price) + " kr"
            addressLabel.text = request.address
            servicePointLabel.text = request.servicePoint
            
            if !shouldShowButton {
                button.isHidden = true
            }
            
            if acceptable {
                acceptButton.isHidden = false
                
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func acceptFriendPickupRequest(_ sender: Any) {
        
        postmanApi.updateRequest(requestId: (request?.id)!, accepted: true)
    }
    @IBAction func pickupClicked(_ sender: Any) {
        postmanApi.updateRequest(requestId: (request?.id)!, accepted: true)
    }
    
    
    @IBOutlet weak var button: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
