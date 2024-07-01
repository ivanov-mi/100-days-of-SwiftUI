//
//  MissionCrewSwipeView.swift
//  Moonshot
//
//  Created by Martin Ivanov on 4/25/24.
//

import SwiftUI

struct MissionCrewSwipeView: View {
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink(value: crewMember.astronaut) {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                    .accessibilityLabel(crewMember.astronaut.name.replacingOccurrences(of: ".", with: " "))
                                
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .navigationDestination(for: Astronaut.self) { astronaut in
                        AstronautView(astronaut: astronaut)
                    }
                }
            }
            .background(.darkBackground)
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    let crew = missions.first!.crew.map { member in
        CrewMember(astronaut: astronauts[member.name]!, role: member.role)
    }
    
    return MissionCrewSwipeView(crew: crew)
        .preferredColorScheme(.dark)
}
