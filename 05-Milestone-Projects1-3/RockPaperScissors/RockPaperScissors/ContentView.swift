//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Martin Ivanov on 4/16/24.
//

import SwiftUI

struct GameObjectiveLabel: View {
    let goal: Goal

    var body: some View {
        HStack {
            Text("How to")
            Text(goal.rawValue)
                .foregroundStyle(goal == .win ? .green : .red)
                .fontWeight(.bold)
            Text("this game?")
        }
        .font(.title)
    }
}

struct ContentView: View {
    @State private var game = RockPaperScissors()
    @State private var round = 1
    @State private var score = 0
    @State private var isGameOver = false
    
    private let shapeSize = UIScreen.main.bounds.size.width / 4
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.init(red: 0.5, green: 0.2, blue: 0.5, opacity: 0.15), .orange], center: .center, startRadius: 200, endRadius: 900)
                .ignoresSafeArea()
            
            VStack {
                Text("Round \(round)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                Spacer()
                
                Text(game.gameSelection.symbol)
                    .font(.system(size: shapeSize))
                
                Spacer()
                
                GameObjectiveLabel(goal: game.goal)
                
                Spacer()
                
                HStack {
                    ForEach(Shape.allCases, id: \.id) { shape in
                        Button {
                            buttonTapped(with: shape)
                        } label: {
                            Text(shape.symbol)
                                .font(.system(size: shapeSize))
                        }
                    }
                }
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
        }
        .alert("Game Over", isPresented: $isGameOver) {
            Button("Play again", action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    private func buttonTapped(with symbol: Shape) {
        score += game.shouldWin(shape: symbol) ? 1 : -1
        round += 1
        isGameOver = round >= 10 ? true : false
        game = RockPaperScissors()
    }
    
    private func resetGame() {
        score = 0
        round = 1
        isGameOver = false
        game = RockPaperScissors()
    }
}

#Preview {
    ContentView()
}
