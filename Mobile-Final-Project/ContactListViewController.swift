//
//  ContactListViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ClientDetailViewControllerDelegate, EditClientViewControllerDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var contacts: [Contact] = []
    var selectedCellIdx: Int = 0
    
    let dbHelper = DBHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.dataSource = self
        listTableView.delegate = self
        fetchData()
        listTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        listTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchData()
        listTableView.reloadData()
    }
    
    func fetchData() {
        dbHelper.openDB()
        contacts = dbHelper.fetchAllContacts()
        dbHelper.closeDB()
        print("list data fetched")
    }
    
    func didDelete() {
        fetchData()
        listTableView.reloadData()
    }
    
    func didUpdate() {
        fetchData()
        listTableView.reloadData()
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
        let clientDetailVC = storyboard?.instantiateViewController(withIdentifier: "ClientDetailViewController") as! ClientDetailViewController
        clientDetailVC.delegate = self
        self.performSegue(withIdentifier: "segueShowContact", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowContact") {
            if let contactDetailVC = segue.destination as? ClientDetailViewController {
                contactDetailVC.delegate = self
                contactDetailVC.selectedContact = contacts[selectedCellIdx]
            }
        }
    }
}


