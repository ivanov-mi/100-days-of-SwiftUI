//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Martin Ivanov on 4/29/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                        .onAppear {
                            saveAddress()
                        }
                }
            }
            .disabled(!order.hasValidAddress)
            
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveAddress() {
        let address = Address(name: order.name,
                               streetAddress: order.streetAddress,
                               city: order.city,
                               zip: order.zip)
        AddressPersistenceManager.save(address: address)
    }
}

#Preview {
    AddressView(order: Order())
}
