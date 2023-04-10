//
//  ClientDetailViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit

class ClientDetailViewController: UIViewController {
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    
    var selectedContact : Contact!
    
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
        
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        
    }
    
}
