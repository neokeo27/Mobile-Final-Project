//
//  ContactFormViewController.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/7/23.
//

import UIKit
import SQLite3

class ContactFormViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    var db: OpaquePointer?
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var address: String?
    var phone: String?
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openDB()
        createTable()
        closeDB()
    }

    @IBAction func btnSaveContact(_ sender: UIButton) {
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
        let createQuery = "CREATE TABLE IF NOT EXISTS myContacts (id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, email TEXT, address TEXT, phone TEXT, note TEXT);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, createQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error creating table")
            } else {
                print("table created")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func saveData() {
        firstName = txtFirstName.text
        lastName = txtLastName.text
        email = txtEmail.text
        address = txtAddress.text
        phone = txtPhone.text
        note = txtNote.text
        
        let insertQuery = "INSERT INTO myContacts (firstName, lastName, email, address, phone, note) VALUES (?, ?, ?, ?, ?, ?)"
        var statement: OpaquePointer?
        if sqlite3_prepare(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, firstName ?? "", -1, nil)
            sqlite3_bind_text(statement, 2, lastName ?? "", -1, nil)
            sqlite3_bind_text(statement, 3, email ?? "", -1, nil)
            sqlite3_bind_text(statement, 4, address ?? "", -1, nil)
            sqlite3_bind_text(statement, 5, phone ?? "", -1, nil)
            sqlite3_bind_text(statement, 6, note ?? "", -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting into table")
            } else {
                print("contact inserted")
            }
        }
        sqlite3_finalize(statement)
    }
    
    
    
    
    


}
