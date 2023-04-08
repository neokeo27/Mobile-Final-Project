//
//  ClientDetailViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import SQLite3
import UIKit

class ClientDetailViewController: UIViewController {
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    
    var selectedContact : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func btnSaveNote(_ sender: UIButton) {
        
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        
    }
    
}
