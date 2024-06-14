//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Martin Ivanov on 6/12/24.
//

import SwiftUI

enum SortType: String, CaseIterable {
    case `default` = "Default"
    case alphabetical = "Alphabetical"
    case country = "By Country"
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favorites = Favorites()
    @State private var searchText = ""
    @State private var sortType = SortType.default
    @State private var showOptionsVisible = false
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            resorts
        } else {
            resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var sortedResults: [Resort] {
        switch sortType {
        case .alphabetical:
            filteredResorts.sorted(by: \.name)
        case .country:
            filteredResorts.sorted(by: \.country)
        case .default:
            filteredResorts
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(sortedResults) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Button("Sort order", systemImage:  "arrow.up.arrow.down") {
                    showOptionsVisible = true
                }
            }
            .confirmationDialog("Sort order", isPresented: $showOptionsVisible) {
                ForEach(SortType.allCases, id: \.rawValue) { type in
                    Button(type.rawValue) { sortType = type }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
