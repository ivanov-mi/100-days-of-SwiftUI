//
//  CustomDividerView.swift
//  Moonshot
//
//  Created by Martin Ivanov on 4/25/24.
//

import SwiftUI

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    CustomDividerView()
}
