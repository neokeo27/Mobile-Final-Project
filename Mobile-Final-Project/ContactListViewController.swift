//
//  ContactListViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ClientDetailViewControllerDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var contacts: [Contact] = []
    var selectedCellIdx: Int = 0
    
    let dbHelper = DBHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        //listTableView.reloadData()
        populateList()
        listTableView.reloadData()
    }
    
    func populateList() {
        dbHelper.openDB()
        contacts = dbHelper.fetchAllContacts()
        dbHelper.closeDB()
        print("List populated")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let contactName = cell.viewWithTag(1) as! UILabel
        contactName.text = "\(contacts[indexPath.row].lastName ?? ""), \(contacts[indexPath.row].firstName ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIdx = indexPath.row
        self.performSegue(withIdentifier: "segueShowContact", sender: nil)
    }
    
    func didDelete() {
        listTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowContact") {
            let vc = segue.destination as! ClientDetailViewController
            vc.selectedContact = contacts[selectedCellIdx]
//            vc.onDeleteContact = { [weak self] in self?.listTableView.reloadData()}
            vc.delegate = self
        }
    }
}
