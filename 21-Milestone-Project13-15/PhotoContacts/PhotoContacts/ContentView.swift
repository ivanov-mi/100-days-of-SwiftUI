//
//  ContentView.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var addingNewContact = false
    @State private var contacts: [Contact] = []
    
    var body: some View {
        NavigationStack {
            List(contacts) { contact in
                NavigationLink(value: contact) {
                    HStack {
                        let image = loadImage(with: contact.id)
                        image?
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(contact.name)
                    }
                }
            }
            .navigationBarTitle("PhotoContacts")
            .navigationDestination(for: Contact.self) { contact in
                ContactView(contact: contact)
            }
            .sheet(isPresented: $addingNewContact, onDismiss: loadData) {
                AddContactView(contacts: $contacts)
            }
            .toolbar {
                Button {
                    addingNewContact = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: loadData)
    }
    
    private func loadData() {
        do {
            let data = try Data(contentsOf: PersistenceHelper.contactsSavePath)
            let decodedContent = try? JSONDecoder().decode([Contact].self, from: data)
            if let persons = decodedContent {
                contacts = persons.sorted()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadImage(with id : UUID) -> Image? {
        let imagePath = PersistenceHelper.pathForImage(with: id).path
        guard let uiImage = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
