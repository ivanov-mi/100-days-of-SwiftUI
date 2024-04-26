//
//  ContentView.swift
//  Moonshot
//
//  Created by Martin Ivanov on 4/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showGrid = false
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationStack {
            Group {
                if showGrid {
                    GridLayoutView(astronauts: astronauts, missions: missions)
                } else {
                    ListLayoutView(astronauts: astronauts, missions: missions)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Change Layout") {
                        showGrid.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
