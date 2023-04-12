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

class ClientDetailViewController: UIViewController, UITextViewDelegate {
    
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
    
    func refreshData() {
        contactID = getContactID()
        dbHelper.openDB()
        let freshContact = dbHelper.fetchContactByID(contactID: contactID)
        dbHelper.closeDB()
        
        selectedContact.firstName = freshContact?.firstName
        selectedContact.lastName = freshContact?.lastName
        selectedContact.email = freshContact?.email
        selectedContact.address = freshContact?.address
        selectedContact.phone = freshContact?.phone
        selectedContact.note = freshContact?.note
        populateDetails()
    }
    
    @IBAction func btnSaveNote(_ sender: UIButton) {
        contactID = getContactID()
        let newNote = txtNote.text
        selectedContact.note = newNote
        updateNote()
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
            let vc = segue.destination as! EditClientViewController
            vc.editContact = selectedContact
        }
    }
    
    func textFieldDone(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onBackgroundTap(_ sender: Any) {
        txtNote.resignFirstResponder()
    }
}

extension ClientDetailViewController: EditClientViewControllerDelegate {
    func didUpdate() {
        refreshData() 
        let editClientVC = storyboard?.instantiateViewController(withIdentifier: "EditClientViewController") as! EditClientViewController
    }
}
