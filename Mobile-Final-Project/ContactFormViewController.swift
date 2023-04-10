//
//  ContactFormViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class ContactFormViewController: UIViewController {
    
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

        dbHelper.openDB()
        dbHelper.createTable()
        //dbHelper.droptable()
        dbHelper.closeDB()
    }

    @IBAction func btnSaveContact(_ sender: UIButton) {
        saveData()
    }
    
    func saveData() {
        firstName = txtFirstName.text
        lastName = txtLastName.text
        email = txtEmail.text
        address = txtAddress.text
        phone = txtPhone.text
        note = txtNote.text
        let newContact = Contact(firstName: firstName, lastName: lastName, email: email, address: address, phone: phone, note: note)
        dbHelper.openDB()
        dbHelper.insertContact(contact: newContact)
        dbHelper.closeDB()
        clearForm()
    }
    
    func clearForm() {
        txtFirstName.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtAddress.text = ""
        txtPhone.text = ""
        txtNote.text = ""
    }
}
