//
//  ContentView.swift
//  CustomTitleViewModifier
//
//  Created by Martin Ivanov on 4/15/24.
//

import SwiftUI

struct CustomTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 20))
    }
}

extension View {
    func customTitleStyle() -> some View {
        self.modifier(CustomTitle())
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .customTitleStyle()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
