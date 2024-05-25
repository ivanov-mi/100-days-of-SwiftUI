//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Martin Ivanov on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
