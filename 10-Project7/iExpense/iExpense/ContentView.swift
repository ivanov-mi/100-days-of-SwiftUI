//
//  ContentView.swift
//  iExpense
//
//  Created by Martin Ivanov on 4/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ExpenseType.allCases, id: \.id) { type in
                    Section(header: Text(type.rawValue)) {
                        let expansesGroup = expenses.items.filter { $0.type == type }
                        
                        if expansesGroup.count > 0 {
                            ForEach(expansesGroup, id: \.id) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        
                                        Text(item.type.rawValue)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                }
                                .foregroundColor(associatedColor(with: item.amount))
                            }
                        } else {
                            Text("No \(type.rawValue) records available").deleteDisabled(true)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func associatedColor(with amount: Double) -> Color {
        if amount < 10.0 {
            return .green
        } else if amount < 100.0 {
            return .orange
        }
        
        return .red
    }
}

#Preview {
    ContentView()
}
