//
//  Activities.swift
//  HabitTracking
//
//  Created by Martin Ivanov on 6/17/24.
//

import Foundation

@Observable
class Activities {
    var activities: [Activity] {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.setValue(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        guard let saved = UserDefaults.standard.data(forKey: "Activities"),
           let decoded = try? JSONDecoder().decode([Activity].self, from: saved) else {
            activities = []
            return
        }
        
        activities = decoded
    }
}
