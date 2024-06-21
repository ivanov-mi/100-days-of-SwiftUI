//
//  ContactView.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import SwiftUI

struct ContactView: View {
    var contact: Contact
    
    var body: some View {
        VStack {
            Text(contact.name)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding()
            
            contact.image?
                .resizable()
                .scaledToFit()
                .padding(.bottom)
            Spacer()
        }
    }
}

#Preview {
    ContactView(contact: Contact(name: "test"))
}
