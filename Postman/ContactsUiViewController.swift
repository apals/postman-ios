//
//  ContactsUiViewController.swift
//  Postman
//
//  Created by Axel Riese on 2017-02-16.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class ContactsUiViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var store = CNContactStore()
    var contacts: [CNContact] = []
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        if let query = textField.text {
            findContactsWithName(name: query)
        }
    }
    
    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
                        self.contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let askTableViewController = segue.destination as! AskTableViewController
        
        // Get the cell that generated this segue.
        if let selectedContactCell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: selectedContactCell)!
            let selectedContact = contacts[indexPath.row]
            askTableViewController.name = selectedContact.givenName + " " + selectedContact.familyName
            askTableViewController.phone = (selectedContact.phoneNumbers[0].value ).value(forKey: "digits") as? String
        }
    }

}

extension ContactsUiViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        cell!.textLabel!.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        
        return cell!
    }
}

//extension ContactsUiViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = CNContactViewController(for: contacts[indexPath.row])
//        controller.contactStore = self.store
//        controller.allowsEditing = false
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    
//}
