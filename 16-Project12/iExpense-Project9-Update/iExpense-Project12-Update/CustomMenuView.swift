//
//  CustomMenuView.swift
//  iExpense-Project12-Update
//
//  Created by Martin Ivanov on 5/16/24.
//

import SwiftUI

struct CustomMenuView: View {
    @Binding var sortOrder: SortDescriptor<ExpenseItem>
    @Binding var typeFilter: [ExpenseType]
    
    @Binding var showingAddExpense: Bool
    
    var body: some View {
        Menu {
            Section {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            
            Section() {
                ForEach(ExpenseType.allCases, id: \.id) { type in
                    Button(action: {
                        toogleSelectedTypes(for: type)
                    }, label: {
                        HStack {
                            if typeFilter.contains(type) {
                                Image(systemName: "checkmark")
                            }
                            Text("Show \(type.rawValue)")
                        }
                    })
                }
            }
            
            Section() {
                Picker("Sort", selection: $sortOrder) {
                    Text("Sort by name")
                        .tag(SortDescriptor(\ExpenseItem.name))
                    
                    Text("Sort by amount")
                        .tag(SortDescriptor(\ExpenseItem.amount))
                    
                    Text("Sort by type")
                        .tag(SortDescriptor(\ExpenseItem.type))
                }
            }
        } label: {
            Label("Menu", systemImage: "ellipsis.circle")
        }
    }
    
    private func toogleSelectedTypes(for type: ExpenseType) {
        if typeFilter.contains(type) {
            typeFilter.removeAll(where: { $0 == type })
        } else {
            typeFilter.append(type)
        }
    }
}

#Preview {
    @State var sortOrder = SortDescriptor(\ExpenseItem.name)
    @State var typeFilter = [ExpenseType.personal]
    @State var showingAddExpense = true
    
    return CustomMenuView(sortOrder: $sortOrder, typeFilter: $typeFilter, showingAddExpense: $showingAddExpense)
}
