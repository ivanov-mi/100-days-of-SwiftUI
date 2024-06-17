//
//  ContentView.swift
//  HabitTracking
//
//  Created by Martin Ivanov on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var data = Activities()
    @State private var addingNewActivity = false
    
    var body: some View {
        NavigationStack {
            List(data.activities) { activity in
                NavigationLink {
                    ActivityView(data: data, activity: activity)
                } label: {
                    HStack {
                        Text(activity.title)
                        
                        Spacer()
                        
                        Text(String(activity.completionCount))
                            .font(.caption.weight(.black))
                            .padding(5)
                            .frame(minWidth: 50)
                            .background(color(for: activity))
                            .foregroundColor(.white)
                            .clipShape(.capsule)
                    }
                }
            }
            .navigationTitle("HabitTracking")
            .toolbar {
                Button("Add new activity", systemImage: "plus") {
                    addingNewActivity.toggle()
                }
            }
            .sheet(isPresented: $addingNewActivity) {
                AddActivity(data: data)
            }
        }
    }
    
    func color(for activity: Activity) -> Color {
        switch activity.completionCount {
        case 0..<3:
                .red
        case 3..<10:
                .orange
        case 10..<20:
                .green
        case 20..<50:
                .blue
        default:
                .indigo
        }
    }
}

#Preview {
    ContentView()
}
