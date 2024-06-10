//
//  CardView.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/3/24.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var offset = CGSize.zero
    
    @Binding var card: CardViewModel
    var removal: ((_ shouldRestack: Bool) -> Void)?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50.0)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25.0)
                        .fill(cardBackgroundColor(offset: offset))
                )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(card.showAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if card.showAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5.0)
        .opacity(2 - Double(abs(offset.width / 50.0)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded {_ in
                    if abs(offset.width) > 100 {
                        let shouldRestack = offset.width < 0
                        
                        if shouldRestack {
                            offset = .zero
                            card.showAnswer = false
                        }
                        
                        removal?(shouldRestack)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            card.showAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
    
    private func cardBackgroundColor(offset: CGSize) -> Color {
        if offset.width > 0 {
            return .green
        }

        if offset.width < 0 {
            return .red
        }

        return .white
    }
}

#Preview {
    @State var exampleCard = CardViewModel(card: Card(id: UUID(), prompt: "Who player the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker"))
    
    return CardView(card: $exampleCard)
}
