//
//  Prospect.swift
//  HotProspects
//
//  Created by Martin Ivanov on 5/24/24.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    let dateAdded: Date
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.dateAdded = Date()
    }
}


