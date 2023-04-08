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
        // Initialize the database connection
        openDB()
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

    deinit {
        closeDB()
    }
}
