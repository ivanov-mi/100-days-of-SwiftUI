//
//  Contact.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import Foundation
import SwiftUI
import MapKit

struct Contact : Codable, Identifiable, Comparable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double?
    let longitude: Double?
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    init(name: String, latitude: Double?, longitude: Double?) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var image : Image? {
        let imagePath = URL.documentsDirectory.appending(path: "\(id.uuidString).jpg").path
        guard let uiImage = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
