//
//  Expenses.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import Foundation

@Observable
class Expenses: Codable {
    var items: [ExpenseItem] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        guard let savedItems = UserDefaults.standard.data(forKey: "Items"),
              let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) else {
            items = []
            return
        }
        
        items = decodedItems
    }
}
