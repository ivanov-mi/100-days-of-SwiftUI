//
//  ContentView.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/3/24.
//

import SwiftUI
import SwiftData

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var cards: [Card]
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment (\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @State private var cardsInPlay: [CardViewModel] = []
    
    @State private var timeRemaining = 100
    @State private var showingEditScreen = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach($cardsInPlay, id: \.id) { $card in
                        CardView(card: $card) { shouldRestack in
                            withAnimation {
                                if shouldRestack {
                                    restackCard(card)
                                } else {
                                    remove(card)
                                }
                            }
                        }
                        .stacked(at: index(for: card), in: cardsInPlay.count)
                        .allowsHitTesting(card.id == cardsInPlay.last?.id)
                        .accessibility(hidden: card.id != cardsInPlay.last?.id)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cardsInPlay.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                guard var topCard = cardsInPlay.last else { return }
                                topCard.showAnswer = false
                                restackCard(topCard)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                guard var topCard = cardsInPlay.last else { return }
                                topCard.showAnswer = true
                                remove(topCard)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                }
                .foregroundStyle(.white)
                .font(.largeTitle)
                .padding()
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cardsInPlay.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    private func remove(_ card: CardViewModel) {
        cardsInPlay.removeAll(where: { $0.id == card.id })
        
        if cardsInPlay.isEmpty {
            isActive = false
        }
    }
    
    private func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    private func loadData() {
        cardsInPlay = cards.compactMap { CardViewModel(card: $0) }
    }
    
    private func index(for card: CardViewModel) -> Int {
        cardsInPlay.firstIndex(where: { $0.id == card.id }) ?? 0
    }
    
    private func restackCard(_ card: CardViewModel) {
        cardsInPlay.removeAll(where: { $0.id == card.id })
        cardsInPlay.insert(card, at: 0)
    }
}

#Preview {
    ContentView()
}
