//
//  EditView.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/20/24.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading
        case loaded
        case failed
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.location.name)
                    TextField("Description", text: $viewModel.location.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageId) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        let viewModel = ViewModel(location: location, onSave: onSave)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
