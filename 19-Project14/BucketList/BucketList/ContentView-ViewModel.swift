//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/20/24.
//

import SwiftUI
import MapKit
import CoreLocation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var showingAlert: Bool = false {
            didSet {
                if !showingAlert {
                    authenticationError = nil
                }
            }
        }
        var authenticationError: AuthenticationError?
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace,
                  let index = locations.firstIndex(of: selectedPlace) else {
                return
            }
            
            locations[index] = location
            save()
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        guard let errorDescription = authenticationError?.localizedDescription else {
                            self.authenticationError = AuthenticationError.unknown
                            return
                        }
                        
                        self.authenticationError = AuthenticationError.authenticationFailed(localizedDescription: errorDescription)
                        self.showingAlert = true
                    }
                }
            } else {
                authenticationError = AuthenticationError.biometricsUnavailable
                showingAlert = true
            }
        }
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
    }
}
