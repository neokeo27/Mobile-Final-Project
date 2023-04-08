//
//  ContactListViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit
import SQLite3

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var contacts: [String] = []
    var selectedCellIdx: Int = 0
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        
        retrieveData()
    }
    
    func retrieveData() {
        let selectQuery = "SELECT lastName, firstName FROM myContacts ORDER BY lastName;"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let lastName = String(cString: sqlite3_column_text(statement, 0))
                let firstName = String(cString: sqlite3_column_text(statement, 1))
                let contact = "\(lastName), \(firstName)"
                contacts.append(contact)
            }
        }
        sqlite3_finalize(statement)
        listTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contactName = cell.viewWithTag(1) as! UILabel
        contactName.text = contacts[indexPath.row]
        
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
