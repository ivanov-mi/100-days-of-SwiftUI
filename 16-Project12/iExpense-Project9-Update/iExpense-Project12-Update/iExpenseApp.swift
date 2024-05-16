//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
