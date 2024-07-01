//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import Foundation
import SwiftData

enum ExpenseType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case personal = "Personal"
    case business = "Business"
}

@Model
class ExpenseItem {
    var id = UUID()
    var name: String
    var type: ExpenseType.RawValue
    var amount: Double
    
    init(id: UUID = UUID(), name: String, type: ExpenseType, amount: Double) {
        self.id = id
        self.name = name
        self.type = type.rawValue
        self.amount = amount
    }
}
