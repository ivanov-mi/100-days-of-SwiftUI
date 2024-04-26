//
//  GridLayoutView.swift
//  Moonshot
//
//  Created by Martin Ivanov on 4/25/24.
//

import SwiftUI

struct GridLayoutView: View {
    private let columns = [GridItem(.adaptive(minimum: 150))]
    
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(missions) { mission in
                    NavigationLink(value: mission) {
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            
                            VStack {
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(.rect(cornerRadius: 10.0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.lightBackground)
                        )
                    }
                    .navigationDestination(for: Mission.self) { mission in
                        MissionView(mission: mission, astronauts: astronauts)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    return GridLayoutView(astronauts: astronauts, missions: missions)
        .background(.darkBackground)
        .preferredColorScheme(.dark)
}
