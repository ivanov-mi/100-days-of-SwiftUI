//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Martin Ivanov on 6/12/24.
//

import SwiftUI

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"
    
    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            resorts = []
            return
        }
        
        resorts = decoded
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
