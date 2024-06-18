//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Martin Ivanov on 6/17/24.
//

import SwiftUI
import SwiftData

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
