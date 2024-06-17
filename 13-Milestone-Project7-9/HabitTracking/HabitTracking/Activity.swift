//
//  Activity.swift
//  HabitTracking
//
//  Created by Martin Ivanov on 6/17/24.
//

import Foundation

struct Activity: Codable, Equatable, Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount = 0
    
    static let example = Activity(title: "Example activity", description: "Test activity")
}
