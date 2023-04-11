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
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var address: String?
    var phone: String?
    
    var contactID: Int!
    
    var editContact : Contact!
    
    let dbHelper = DBHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDetails()
    }
    
    @IBAction func btnSaveContact(_ sender: UIButton) {
        saveData()
        self.dismiss(animated: true)
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
        firstName = editFirstName.text
        lastName = editLastName.text
        email = editEmail.text
        address = editAddress.text
        phone = editPhone.text
        
        if validateData(email: email, phone: phone) {
            dbHelper.openDB()
            contactID = dbHelper.getContactId(email: email!)
            dbHelper.updateContact(contactID: contactID, contact: editContact)
            dbHelper.closeDB()
            
            let controller = UIAlertController(title: "Success!", message: "Contact has been Updates", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
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
}
