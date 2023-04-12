//
//  Contact.swift
//  Mobile-Final-Project
//
//  Created by Jordan Keough on 4/8/23.
//

import UIKit

public struct Contact {
    var firstName: String?
    var lastName: String?
    var email: String?
    var address: String?
    var phone: String?
    var note: String?
    
    init(firstName: String?, lastName: String?, email: String?, address: String?, phone: String?, note: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.address = address
        self.phone = phone
        self.note = note
    }
    
    init() {
        firstName = "John"
        lastName = "Doe"
        email = "noemail@web.net"
        address = nil
        phone = "0"
        note = nil
    }
}
