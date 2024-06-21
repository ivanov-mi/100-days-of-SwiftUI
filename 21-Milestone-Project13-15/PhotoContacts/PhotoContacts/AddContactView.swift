//
//  AddContactView.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import SwiftUI
import PhotosUI

private enum ValidationAlert {
    case emptyImage
    case emptyName
    
    var title: String {
        switch self {
        case .emptyImage:
            "Image can not be empty."
        case .emptyName:
            "Name can not be empty."
        }
    }
    
    var message: String {
        switch self {
        case .emptyImage:
            "Please select an Image"
        case .emptyName:
            "Please enter a name."
        }
    }
}

struct AddContactView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var contacts : [Contact]
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var name = ""
    @State private var showingAlert = false
    @State private var alertType: ValidationAlert? {
        didSet {
            showingAlert = true
        }
    }
    
    var image: Image? {
        uiImage != nil ? Image(uiImage: uiImage!) : nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $selectedItem) {
                        if let image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedItem, loadImage)
                }
                
                Section {
                    TextField("Name", text: $name)
                }
            }
            .navigationTitle("Add New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard image != nil else {
                            alertType = .emptyImage
                            return
                        }
                        
                        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            alertType = .emptyName
                            return
                        }
                        
                        saveData()
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertType?.title ?? ""), message: Text(alertType?.message ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func loadImage() {
        Task {
            guard let imageData = try? await selectedItem?.loadTransferable(type: Data.self) else {
                uiImage = nil
                return
            }
            
            uiImage = UIImage(data: imageData)
        }
    }
    
    private func saveData() {
        let contact = Contact(name: name)
        contacts.append(contact)
        contacts.sort()
        
        do {
            let data = try JSONEncoder().encode(contacts)
            try data.write(to: PersistenceHelper.contactsSavePath, options: [.atomic, .completeFileProtection])
            if let jpegData = uiImage?.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: PersistenceHelper.pathForImage(with: contact.id), options: [.atomic, .completeFileProtection])
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    @State var contacts: [Contact] = []
    return AddContactView(contacts: $contacts)
}
