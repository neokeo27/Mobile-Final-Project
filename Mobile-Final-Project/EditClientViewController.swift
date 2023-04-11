//
//  EditClientViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class EditClientViewController: UIViewController {
    
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editAddress: UITextField!
    @IBOutlet weak var editPhone: UITextField!
    @IBOutlet weak var textNote: UITextView!
    
    var newFirstName: String?
    var newLastName: String?
    var newEmail: String?
    var newAddress: String?
    var newPhone: String?
    
    var contactID: Int!
    
    var editContact : Contact!
    
    let dbHelper = DBHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDetails()
    }
    
    @IBAction func btnSaveContact(_ sender: UIButton) {
        saveData()
        dismiss(animated: true)
    }
    
    func populateDetails() {
        editFirstName.text = editContact.firstName
        editLastName.text = editContact.lastName
        editEmail.text = editContact.email
        editAddress.text = editContact.address
        editPhone.text = editContact.phone
        textNote.text = editContact.note
    }
    
    func saveData() {
        newFirstName = editFirstName.text
        newLastName = editLastName.text
        newEmail = editEmail.text
        newAddress = editAddress.text
        newPhone = editPhone.text
        
        if validateData(email: newEmail, phone: newPhone) {
            getContactID()
            updateContact()
            
            let controller = UIAlertController(title: "Success!", message: "Contact has been Updated", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    func getContactID() {
        dbHelper.openDB()
        contactID = dbHelper.getContactId(email: newEmail!)
        dbHelper.closeDB()
    }
    
    func updateContact() {
        dbHelper.openDB()
        dbHelper.updateContact(contactID: contactID, contact: editContact)
        dbHelper.closeDB()
    }
    
    func validateData(email: String!, phone: String!) -> Bool{
        if !dbHelper.isEmailValid(email: email!) {
            let controller = UIAlertController(title: "Error", message: "Email is invalid", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
            return false
        }
        
        if !dbHelper.isPhoneValid(phone: phone!) {
            let controller = UIAlertController(title: "Error", message: "Phone Number is invalid", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDone(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onBackgroundTap(_ sender: Any) {
        editFirstName.resignFirstResponder()
        editLastName.resignFirstResponder()
        editEmail.resignFirstResponder()
        editAddress.resignFirstResponder()
        editPhone.resignFirstResponder()
        textNote.resignFirstResponder()
    }
}
