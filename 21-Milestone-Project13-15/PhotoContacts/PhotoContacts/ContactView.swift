//
//  ContactView.swift
//  PhotoContacts
//
//  Created by Martin Ivanov on 6/19/24.
//

import SwiftUI
import MapKit

struct ContactView: View {
    @State private var selectedTab = 0
    
    let contact: Contact
    let tabs = ["Details", "Location"]
    
    var body: some View {
        VStack {
            Picker("Contact Info", selection: $selectedTab) {
                Text("Details").tag(0)
                Text("Location").tag(1)
            }
            .pickerStyle(.segmented)
            
            if selectedTab == 0 {
                Text(contact.name)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .padding()
                
                contact.image?
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom)
                Spacer()
            } else {
                if let coordinate = contact.coordinate {
                    let position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        ))
                    
                    Map(initialPosition: position) {
                        Annotation("Meeting place", coordinate: coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                        }
                    }
                    .mapStyle(.standard)
                } else {
                    Text("No location information")
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContactView(contact: Contact(name: "test", latitude: nil, longitude: nil))
}
