//
//  EditView.swift
//  HotProspects
//
//  Created by Martin Ivanov on 5/25/24.
//

import SwiftUI
import SwiftData

struct EditView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var prospect: Prospect
    @State private var name: String
    @State private var emailAddress: String
    
    private var saveButtonShown: Bool {
        name != prospect.name || emailAddress != prospect.emailAddress
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
            }
        }
        .navigationTitle("Edit contact")
        .toolbar {
            if saveButtonShown {
                Button("Save") {
                    prospect.name = name
                    prospect.emailAddress = emailAddress
                    try? modelContext.save()
                    
                    dismiss()
                }
            }
        }
    }
    
    init(prospect: Prospect) {
        self.prospect = prospect
        self.name = prospect.name
        self.emailAddress = prospect.emailAddress
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Prospect.self, configurations: config)
        let prospect = Prospect(name: "Name", emailAddress: "Email", isContacted: false)
        
        return EditView(prospect: prospect)
            .modelContainer(for: Prospect.self)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
    
}
