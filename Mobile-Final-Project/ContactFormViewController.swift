//
//  ContactFormViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class ContactFormViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    let dbHelper = DBHelper.shared
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var address: String?
    var phone: String?
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtNote.delegate = self
        
        dbHelper.openDB()
        dbHelper.createTable()
        //dbHelper.dropTable()
        dbHelper.closeDB()
    }

    @IBAction func btnSaveContact(_ sender: UIButton) {
        saveData()
    }
    
    func validateData(email: String!, phone: String!) -> Bool{
        if !dbHelper.isEmailValid(email: email!) {
            let controller = UIAlertController(title: "Error", message: "Email is invalid", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
            return false
        }
        
        if !dbHelper.isEmailUnique(email: email!) {
            let controller = UIAlertController(title: "Error", message: "Email already exists", preferredStyle: .actionSheet)
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
    
    func saveData() {
        firstName = txtFirstName.text
        lastName = txtLastName.text
        email = txtEmail.text
        address = txtAddress.text
        phone = txtPhone.text
        note = txtNote.text
        
        if validateData(email: email, phone: phone) {
            let newContact = Contact(firstName: firstName, lastName: lastName, email: email, address: address, phone: phone, note: note)
            dbHelper.openDB()
            dbHelper.insertContact(contact: newContact)
            dbHelper.closeDB()
            let controller = UIAlertController(title: "Success!", message: "Contact is Saved", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
            clearForm()
        }
    }
    
    func clearForm() {
        txtFirstName.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtAddress.text = ""
        txtPhone.text = ""
        txtNote.text = ""
    }
    
    @IBAction func textFieldDone(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onBackgroundTap(_ sender: Any) {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtNote.resignFirstResponder()
    }
    
}
