//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/21/24.
//

import Foundation

extension EditView {
    @Observable
    class ViewModel {
        var location: Location
        private(set) var onSave: (Location) -> Void

        private(set) var loadingState = LoadingState.loading
        private(set) var pages: [Page] = []
        
        func save() {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = location.name
            newLocation.description = location.description
            
            onSave(newLocation)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            self.onSave = onSave
        }
    }
}
