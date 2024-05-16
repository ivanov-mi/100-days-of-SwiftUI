//
//  AddView.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var expense: ExpenseItem
    
    @State private var name = ""
    @State private var type = ExpenseType.personal
    @State private var amount = 0.0

    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            
                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases, id: \.id) {
                        Text($0.rawValue)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    expense.name = name
                    expense.amount = amount
                    expense.type = type.rawValue
                    
                    if !name.isEmpty && amount > 0.0 {
                        modelContext.insert(expense)
                    }
                    
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ExpenseItem.self, configurations: config)
        let expense = ExpenseItem(name: "Brunch", type: ExpenseType.personal, amount: 10.27)
        
        return AddView(expense: expense)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
