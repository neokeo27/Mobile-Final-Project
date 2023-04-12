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

class ClientDetailViewController: UIViewController, UITextViewDelegate, EditClientViewControllerDelegate {
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    
    var selectedContact : Contact!
    var contactID : Int!
    let dbHelper = DBHelper.shared
    
    weak var delegate: ClientDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNote.delegate = self
        populateDetails(contact: selectedContact)
    }
    
    @IBAction func btnSaveNote(_ sender: UIButton) {
        contactID = getContactID()
        let newNote = txtNote.text
        selectedContact.note = newNote
        updateNote()
    }
    
    func populateDetails(contact: Contact) {
        lblFirstName.text = selectedContact.firstName
        lblLastName.text = selectedContact.lastName
        lblEmail.text = selectedContact.email
        lblAddress.text = selectedContact.address
        lblPhone.text = selectedContact.phone
        txtNote.text = selectedContact.note
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueShowEdit", sender: nil)
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        deleteContact()
    }
    
    func getContactID() -> Int {
        dbHelper.openDB()
        contactID = dbHelper.getContactId(email: selectedContact.email!)
        dbHelper.closeDB()
        return contactID
    }
    
    func didUpdate() {
//        var freshContact = Contact()
//        freshContact = fetchData()
//        populateDetails(contact: freshContact)
    }

    func fetchData() -> Contact {
        contactID = getContactID()
        dbHelper.openDB()
        var freshContact = Contact()
        freshContact = dbHelper.fetchContactByID(contactID: contactID)!
        dbHelper.closeDB()
        return freshContact
    }
    
    func updateNote() {
        dbHelper.openDB()
        dbHelper.updateNote(contactID: contactID, contact: selectedContact)
        dbHelper.closeDB()
    }
    
    func deleteContact() {
        contactID = getContactID()
        let controller = UIAlertController(title: "Delete?", message: "Are you sure?", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in return }

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.dbHelper.openDB()
            self.dbHelper.deleteContact(contactID: self.contactID)
            self.dbHelper.closeDB()
            self.delegate?.didDelete()

            self.dismiss(animated: true)
        }
        
        controller.addAction(cancelAction)
        controller.addAction(deleteAction)

        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueShowEdit") {
            if let editClientVC = segue.destination as? EditClientViewController {
                editClientVC.delegate = self
                editClientVC.editContact = selectedContact
            }
        }
    }
    
    func textFieldDone(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onBackgroundTap(_ sender: Any) {
        txtNote.resignFirstResponder()
    }
}

