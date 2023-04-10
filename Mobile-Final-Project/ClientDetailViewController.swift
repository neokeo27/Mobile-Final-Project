//
//  ClientDetailViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

protocol ClientDetailViewControllerDelegate: AnyObject {
    func didDelete()
}

class ClientDetailViewController: UIViewController {
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    
    var selectedContact : Contact!
    var contactID : Int!
    let dbHelper = DBHelper.shared
    
//    var onDeleteContact: (() -> Void)
    weak var delegate: ClientDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        populateDetails()
    }
    
    func populateDetails() {
        lblFirstName.text = selectedContact.firstName
        lblLastName.text = selectedContact.lastName
        lblEmail.text = selectedContact.email
        lblAddress.text = selectedContact.address
        lblPhone.text = selectedContact.phone
        txtNote.text = selectedContact.note
    }
    
    @IBAction func btnSaveNote(_ sender: UIButton) {
        dbHelper.openDB()
        contactID = dbHelper.getContactId(email: selectedContact.email!)
        dbHelper.updateNote(contactID: contactID, contact: selectedContact)
        dbHelper.closeDB()
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueShowEdit", sender: nil)
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        deleteContact()
        delegate?.didDelete()
    }
    
    func deleteContact() {
        dbHelper.openDB()
        contactID = dbHelper.getContactId(email: selectedContact.email!)
        dbHelper.closeDB()
        let controller = UIAlertController(title: "Delete?", message: "Are you sure?", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in return }

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.dbHelper.openDB()
            self.dbHelper.deleteContact(contactID: self.contactID)
            self.dbHelper.closeDB()
//            self.onDeleteContact?()
            self.dismiss(animated: true)
        }
        controller.addAction(cancelAction)
        controller.addAction(deleteAction)

        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowEdit") {
            let vc = segue.destination as! EditClientViewController
            vc.editContact = selectedContact
        }
    }
    
}
