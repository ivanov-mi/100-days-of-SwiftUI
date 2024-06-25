//
//  ContentView.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var settings = Settings()
    @State private var presentingMultiplication = false
    
    var body: some View {
        NavigationView {
            Group {
                if presentingMultiplication {
                    MultiplicationView(settings: settings, presentingMultiplication: $presentingMultiplication)
                } else {
                    SettingsView(settings: settings, presentingMultiplication: $presentingMultiplication)
                }
            }
            .navigationTitle("Multiplication")
        }
    }
}

#Preview {
    ContentView()
}
