//
//  ContactListViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit
import Contact

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var contacts: [Contact] = []
    var selectedCellIdx: Int = 0
    
   let dbHelper = DBHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        
        populateList()
    }
    
    func populateList() {
        contacts = dbHelper.fetchAllContacts()

        for contact in fetchedContacts {
            if let firstName = contact["firstName"] as? String,
                let lastName = contact["lastName"] as? String,
                let phoneNumber = contact["phoneNumber"] as? String,
                let email = contact["email"] as? String,
                let contactID = contact["contactID"] as? Int {
                let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                    contacts.append(contact)
                }
        }
        listTableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contactName = cell.viewWithTag(1) as! UILabel
        //contactName.text = contacts[indexPath.row]
        contactName.text = "\(contacts[indexpath.row].lastName), \(contacts[indexpath.row].lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIdx = indexPath.row
        self.performSegue(withIdentifier: "segueShowContact", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowContact") {
            let vc = segue.destination as! ClientDetailViewController
            vc.selectedContact = contacts[selectedCellIdx]
        }
    }
}