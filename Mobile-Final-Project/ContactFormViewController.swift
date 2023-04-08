//
//  ContactFormViewController.swift
//  Mobile-Final-Project
//
//  Created by user239393 on 4/7/23.
//

import UIKit
import SQLite3

/// <#Description#>
class ContactFormViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openDB()
        createTable()
        closeDB()
    }


    @IBAction func saveButtonPressed(_ sender: UIButton) {
        openDB()
        saveData()
        closeDB()
    }
    
    
    func openDB() {
        if sqlite3_open(getDBPath(), &db) == SQLITE_OK {
            print("Connected to DB")
        } else {
            print("Connection Failed")
        }
    }
    
    func getDBPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = paths[0]
        let path = (documentsDir as NSString).appendingPathComponent("myDB.sqlite")
        return path
    }
    
    func closeDB() {
        if sqlite3_close(db) == SQLITE_OK {
            print("Disconnected from DB")
        } else {
            print("Failed to Disconnect")
        }
    }
    
    func createTable() {
        
    }
    
    func saveData() {
        
    }


}
