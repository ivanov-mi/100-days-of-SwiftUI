//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import Foundation

enum ExpenseType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case personal = "Personal"
    case business = "Business"
}

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: ExpenseType
    let amount: Double
}
