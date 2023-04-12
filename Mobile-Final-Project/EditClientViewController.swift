//
//  EditClientViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

//protocol EditClientViewControllerDelegate: AnyObject {
//    func didUpdate()
//}

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
    var newContact : Contact!
    
    let dbHelper = DBHelper.shared
    
    //weak var delegate: EditClientViewControllerDelegate?

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
        newContact.firstName = editFirstName.text
        newContact.lastName = editLastName.text
        newContact.email = editEmail.text
        newContact.address = editAddress.text
        newContact.phone = editPhone.text

        getContactID()
        updateContact(contact: newContact)
    }
    
    func getContactID() {
        dbHelper.openDB()
        contactID = dbHelper.getContactId(email: newEmail!)
        dbHelper.closeDB()
    }
    
    func updateContact(contact: contact) {
        dbHelper.openDB()
        dbHelper.updateContact(contactID: contactID, contact: contact)
        dbHelper.closeDB()
    }
    
    func checkEmail(email: String!) -> Bool {
        dbHelper.openDB()
        if !dbHelper.isEmailValid(email: email!){
            let controller = UIAlertController(title: "Error", message: "Email is in an invalid format", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
            dbHelper.closeDB()
            return false
        } else {
            dbHelper.closeDB()
            return true
        }
    }

    func checkPhone(phone: String!) -> Bool {
        dbHelper.openDB()
        if !dbHelper.isPhoneValid(phone: phone!) {
            let controller = UIAlertController(title: "Error", message: "Phone Number is invalid", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
            dbHelper.closeDB()
            return false
        } else {
            dbHelper.closeDB()
            return true
        }
    }
    
    func validateData(email: String!, phone: String!) -> Bool{
        if checkEmail(email: email!) && checkPhone(phone: phone!) {
            return true
        } else {
            return false
        }
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
    
    func updateData() {
        //delegate?.didUpdate()
    }
}
