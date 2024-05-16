//
//  ContentView.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sortOrder = SortDescriptor(\ExpenseItem.name)
    @State private var typeFilter = ExpenseType.allCases
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortOrder: sortOrder, typeFilter: typeFilter)
            .navigationTitle("iExpense")
            .toolbar {
                CustomMenuView(sortOrder: $sortOrder, typeFilter: $typeFilter, showingAddExpense: $showingAddExpense)
            }
            .sheet(isPresented: $showingAddExpense) {
                let expense = ExpenseItem(name: "", type: .personal, amount: 0.0)
                AddView(expense: expense)
            }
        }
    }
}

#Preview {
    ContentView()
}
