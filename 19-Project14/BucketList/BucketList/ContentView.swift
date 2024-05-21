//
//  ContentView.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/20/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // Note: MapStyle does not conform to 'Equatable', so for the binding to work it requires workaround
    private enum MapType {
        case standart
        case hybrid
        
        var style: MapStyle {
            switch self {
            case .standart:
                    .standard
            case .hybrid:
                    .hybrid
            }
        }
    }
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        ))
    
    @State private var viewModel = ViewModel()
    @State private var mapType: MapType = .standart
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                ZStack {
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(mapType.style)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            
                            Image(systemName: "square.2.layers.3d")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(10)
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(.circle)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .strokeBorder(Color.white, lineWidth: 2))
                                .contextMenu {
                                    Button {
                                        mapType = .standart
                                    } label: {
                                        Text("Standart")
                                    }
                                    
                                    Button {
                                        mapType = .hybrid
                                    } label: {
                                        Text("Hybrid")
                                    }
                                }
                                .padding([.trailing], 32)
                        }
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
