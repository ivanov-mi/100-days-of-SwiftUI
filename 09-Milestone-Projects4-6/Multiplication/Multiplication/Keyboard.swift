//
//  Keyboard.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/28/24.
//

import SwiftUI

enum KeyboardActions: Int {
    case k0 = 0, k1, k2, k3, k4, k5, k6, k7, k8, k9, delete, submit, none
}

struct KeyboardTextStyle: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var bgColor: Color = Color.blue
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(maxWidth: width, maxHeight: height)
            .foregroundColor(Color.white)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct Keyboard: View {
    private(set) var action: ((KeyboardActions) -> ())?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 10) {
                
                Spacer()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight:0, maxHeight: .infinity, alignment: Alignment.top)
                
                // First 3 rows
                ForEach(0...2, id: \.self) { row in
                    HStack {
                        ForEach(1...3, id: \.self) { column in
                            let buttonNumber = column + row * 3
                            
                            Button {
                                action?(KeyboardActions.init(rawValue: buttonNumber) ?? .none)
                            } label: {
                                Text("\(buttonNumber)")
                                    .modifier(KeyboardTextStyle(width: buttonWidth(geometry), height: buttonHeight()))
                            }
                        }
                    }
                }
                
                // Last row
                HStack {
                    Button {
                        action?(.delete)
                    } label: {
                        Image(systemName: "delete.left")
                            .modifier(KeyboardTextStyle(width: buttonWidth(geometry), height: buttonHeight(), bgColor: Color.red))
                    }
                    
                    Button {
                        action?(.k0)
                    } label: {
                        Text("0")
                            .modifier(KeyboardTextStyle(width: buttonWidth(geometry), height: buttonHeight()))
                    }
                    
                    Button {
                        action?(.submit)
                    } label: {
                        Text("Submit")
                            .modifier(KeyboardTextStyle(width: buttonWidth(geometry), height: self.buttonHeight(), bgColor: Color.green))
                    }
                }
            }
        }
    }
    
    private func buttonWidth(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 3 - 10
    }
    
    private func buttonHeight() -> CGFloat {
        50
    }
}

#Preview {
    Keyboard()
}
