//
//  DBHelper.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/8/23.
//

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

    func insertContact(firstName: String, lastName: String, email: String, address: String, phone: String, note: String) {
        let insertQuery = "INSERT INTO myContacts (firstName, lastName, email, address, phone, note) VALUES (?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
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

    func fetchAllContacts() -> [[String: Any]] {
        let selectQuery = "SELECT * FROM myContacts ORDER BY lastName ASC;"
        return fetchRows(tableName: "myContacts", condition: selectQuery)
    }

    private func fetchRows(tableName: String, condition: String) -> [[String: Any]] {
        var rows: [[String: Any]] = []
        let selectQuery = "SELECT * FROM \(tableName) \(condition);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                var row: [String: Any] = [:]
                let id = Int(sqlite3_column_int(statement, 0))
                let firstName = String(cString: sqlite3_column_text(statement, 1))
                let lastName = String(cString: sqlite3_column_text(statement, 2))
                let email = String(cString: sqlite3_column_text(statement, 3))
                let address = String(cString: sqlite3_column_text(statement, 4))
                let phone = String(cString: sqlite3_column_text(statement, 5))
                let note = String(cString: sqlite3_column_text(statement, 6))

                row["id"] = id
                row["firstName"] = firstName
                row["lastName"] = lastName
                row["email"] = email
                row["address"] = address
                row["phone"] = phone
                row["note"] = note

                rows.append(row)
            }
            sqlite3_finalize(statement)
        }
        return rows
    }

    func updateContact(contactID: Int, firstName: String, lastName: String, email: String, address: String, phone: String, note: String) {
        let updateQuery = "UPDATE Contacts SET firstName = ?, lastName = ?, email = ?, address = ?, phone = ?, note = ? WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, firstName, -1, nil)
            sqlite3_bind_text(statement, 2, lastName, -1, nil)
            sqlite3_bind_text(statement, 3, email, -1, nil)
            sqlite3_bind_text(statement, 4, address, -1, nil)
            sqlite3_bind_text(statement, 5, phone, -1, nil)
            sqlite3_bind_text(statement, 6, note, -1, nil)
            sqlite3_bind_int(statement, 7, Int32(contactID))
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error updating contact")
            }
            sqlite3_finalize(statement)
        }
    }

    func deleteContact(contactID: Int) {
        let deleteQuery = "DELETE FROM Contacts WHERE id = ?;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(contactID))
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting contact")
            }
        sqlite3_finalize(statement)
        }
    }

    deinit {
        closeDB()
    }
}
