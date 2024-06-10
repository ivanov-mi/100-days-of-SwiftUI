//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/3/24.
//

import SwiftUI
import SwiftData

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
