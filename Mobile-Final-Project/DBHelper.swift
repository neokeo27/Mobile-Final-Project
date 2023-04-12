//
//  DBHelper.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/8/23.
//
import Foundation
import SQLite3

class DBHelper {
    static let shared = DBHelper()
    var db: OpaquePointer?

    private init() {
        
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
        
        //had to find DB location to view in DBBrowser for debugging
        print("Path is: " + path)
        
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
    
    func dropTable() {
        let dropQuery = "DROP TABLE IF EXISTS myContacts"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, dropQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error dropping table")
            } else {
                print("table dropped")
            }
        }
        sqlite3_finalize(statement)
        
    }
    
    func insertContact(contact: Contact) {
        let insertQuery = "INSERT INTO myContacts (firstName, lastName, email, address, phone, note) VALUES (?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (contact.firstName! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (contact.lastName! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (contact.email! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (contact.address! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (contact.phone! as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (contact.note! as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting into table")
            } else {
                print("Contact inserted")
            }
        }
        sqlite3_finalize(statement)
    }

    func fetchAllContacts() -> [Contact] {
        let selectCondition = "ORDER BY lastName ASC"
        return fetchRows(tableName: "myContacts", condition: selectCondition)
    }

    private func fetchRows(tableName: String, condition: String) -> [Contact] {
        var contacts: [Contact] = []
        let selectQuery = "SELECT * FROM \(tableName) \(condition);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                //let id = Int(sqlite3_column_int(statement, 0))
                let firstName = String(cString: sqlite3_column_text(statement, 1))
                let lastName = String(cString: sqlite3_column_text(statement, 2))
                let email = String(cString: sqlite3_column_text(statement, 3))
                let address = String(cString: sqlite3_column_text(statement, 4))
                let phone = String(cString: sqlite3_column_text(statement, 5))
                let note = String(cString: sqlite3_column_text(statement, 6))

                let contact = Contact(firstName: firstName, lastName: lastName, email: email, address: address, phone: phone, note: note)
                contacts.append(contact)
            }
            sqlite3_finalize(statement)
        }
        return contacts
    }
    
    func fetchContactByID(contactID: Int) -> Contact? {
        let selectQuery = "SELECT * FROM myContacts WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let firstName = String(cString: sqlite3_column_text(statement, 1))
                let lastName = String(cString: sqlite3_column_text(statement, 2))
                let email = String(cString: sqlite3_column_text(statement, 3))
                let address = String(cString: sqlite3_column_text(statement, 4))
                let phone = String(cString: sqlite3_column_text(statement, 5))
                let note = String(cString: sqlite3_column_text(statement, 6))

                let contact = Contact(firstName: firstName, lastName: lastName, email: email, address: address, phone: phone, note: note)
                sqlite3_finalize(statement)
                
                return contact
            }
            sqlite3_finalize(statement)
        }
        print("none found with that id")
        return nil
    }

    func updateContact(contactID: Int, contact: Contact) {
        let updateQuery = "UPDATE myContacts SET firstName = ?, lastName = ?, email = ?, address = ?, phone = ? WHERE id = ?;"
        //let updateQuery = "UPDATE myContacts SET firstName = ?, lastName = ?, email = ?, address = ?, phone = ?, note = ? WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (contact.firstName! as NSString).utf8String ?? "", -1, nil)
            sqlite3_bind_text(statement, 2, (contact.lastName! as NSString).utf8String ?? "", -1, nil)
            sqlite3_bind_text(statement, 3, (contact.email! as NSString).utf8String ?? "", -1, nil)
            sqlite3_bind_text(statement, 4, (contact.address! as NSString).utf8String ?? "", -1, nil)
            sqlite3_bind_text(statement, 5, (contact.phone! as NSString).utf8String ?? "", -1, nil)
            //sqlite3_bind_text(statement, 6, (contact.note! as NSString).utf8String ?? "", -1, nil)
            //sqlite3_bind_int(statement, 7, Int32(contactID))
            sqlite3_bind_int(statement, 6, Int32(contactID))
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating contact")
            } else {
                print("contact updated")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func updateNote(contactID: Int, contact: Contact) {
        let updateQuery = "UPDATE myContacts SET note = ? WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (contact.note! as NSString).utf8String ?? "", -1, nil)
            sqlite3_bind_int(statement, 2, Int32(contactID))
            if sqlite3_step(statement) != SQLITE_DONE {
                print("error updating contact note")
            } else {
                print("note updated")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
        
    }

    func isPhoneValid(phone: String) -> Bool {
        let phoneRegex = "^(\\+\\d{1,2}\\s)?\\(?\\d{1,3}\\)?[-.\\s]?\\d{1,3}[-.\\s]?\\d{1,4}$"
        //let phoneRegex = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$"

        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }

    func isEmailUnique(email: String) -> Bool {
        var isUnique = false
        var statement: OpaquePointer?
        let countQuery = "SELECT COUNT(*) FROM myContacts WHERE email = ?;"
        if sqlite3_prepare_v2(db, countQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    let count = Int(sqlite3_column_int(statement, 0))
                    if count == 0 {
                        isUnique = true
                    }
                }
            } else {
                print("Error binding email parameter: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing query: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(statement)

        return isUnique
    }

    
    func getContactId(email: String) -> Int {
        let selectQuery = "SELECT id FROM myContacts WHERE email = ?;"
        var statement: OpaquePointer?
        var contactID: Int = 0
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_ROW {
                contactID = Int(sqlite3_column_int(statement, 0))
            }
        }
        sqlite3_finalize(statement)
        return contactID
    }

    func deleteContact(contactID: Int) {
        let deleteQuery = "DELETE FROM myContacts WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(contactID))
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting contact")
            } else {
                print("contact deleted")
            }
        sqlite3_finalize(statement)
        }
    }

    deinit {
        closeDB()
    }
}
