//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by Martin Ivanov on 7/4/24.
//

import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
