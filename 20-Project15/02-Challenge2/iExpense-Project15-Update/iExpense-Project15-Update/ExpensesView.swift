//
//  ExpensesView.swift
//  iExpense-Project12-Update
//
//  Created by Martin Ivanov on 5/14/24.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [ExpenseItem]
    
    var body: some View {
        List {
            ForEach(expenses, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                .foregroundColor(associatedColor(with: item.amount))
                .accessibilityElement()
                .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))")
                .accessibilityHint(item.type)
            }
            .onDelete(perform: removeItems)
        }
    }
    
    init(sortOrder: SortDescriptor<ExpenseItem>, typeFilter: [ExpenseType]) {
        let filters = typeFilter.compactMap { $0.rawValue }
        
        _expenses = Query(filter: #Predicate<ExpenseItem> { expense in
            filters.contains(expense.type)
        }, sort: [sortOrder])
    }
    
    private func removeItems(at indexSet: IndexSet) {
        indexSet.forEach {
            modelContext.delete(expenses[$0])
        }
    }
    
    private func associatedColor(with amount: Double) -> Color {
        if amount < 10.0 {
            return .green
        } else if amount < 100.0 {
            return .orange
        }
        
        return .red
    }
}

#Preview {
    let sortOrder = SortDescriptor(\ExpenseItem.name)
    let typeFilter = [ExpenseType.personal]
    
    return ExpensesView(sortOrder: sortOrder, typeFilter: typeFilter)
        .modelContainer(for: ExpenseItem.self)
}
