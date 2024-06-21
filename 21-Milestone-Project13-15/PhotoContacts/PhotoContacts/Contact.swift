//
//  Contact.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import Foundation
import SwiftUI

struct Contact : Codable, Identifiable, Comparable, Hashable {
    let id: UUID
    var name: String

    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    var image : Image? {
        let imagePath = URL.documentsDirectory.appending(path: "\(id.uuidString).jpg").path
        guard let uiImage = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}
