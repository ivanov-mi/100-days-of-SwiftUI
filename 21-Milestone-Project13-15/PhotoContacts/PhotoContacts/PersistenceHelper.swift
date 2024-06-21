//
//  PersistenceHelper.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/20/24.
//

import Foundation

enum PersistenceHelper {
    static let contactsSavePath = URL.documentsDirectory.appending(path: "contacts.json")
    
    static func pathForImage(with id: UUID) -> URL {
        URL.documentsDirectory.appending(path: "\(id.uuidString).jpg")
    }
}
