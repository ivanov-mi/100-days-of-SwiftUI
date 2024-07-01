//
//  AddressPersistanceManager.swift
//  CupcakeCorner
//
//  Created by Martin Ivanov on 4/30/24.
//

import Foundation

enum AddressPersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let savedAddress = "savedAddress"
    }
    
    static func retrieveSavedAddress() -> Address? {
        guard let addressData = defaults.object(forKey: Keys.savedAddress) as? Data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let address = try? decoder.decode(Address.self, from: addressData)
        
        return address
    }
    
    static func save(address: Address) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(address) {
            defaults.set(encoded, forKey: Keys.savedAddress)
        }
    }
}
