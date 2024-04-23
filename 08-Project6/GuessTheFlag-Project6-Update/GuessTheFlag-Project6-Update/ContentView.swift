//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Martin Ivanov on 4/11/24.
//

import SwiftUI

private enum Constants {
    static let gameQuestions = 8
    static let nextQuestionAfter = 2.0
    static let flagAnimationDuration = 1.0
    static let scoreUpdateDuration = 0.25
    static let spinDegrees = 360.0
    static let shakes = 3.0
}

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Shake: GeometryEffect {
    private let amount: CGFloat = 20
    private let shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var questionsCounter = 1
    @State private var isGameOver = false
    
    @State private var spinAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var shakeAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var isCorrectAnswer = false
    @State private var animateUpdateScore = false
    @State private var animateOpacity = false
    @State private var isFlagSelected = false
    
    private var finalScoreMessage: String {
        "Your final score is: \(score)"
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .blue.opacity(0.6), location: 0.4),
                .init(color: Color(red: 0.55, green: 0.25, blue: 0.95), location: 0.4)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        .rotation3DEffect(.degrees(spinAnimationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        .modifier(Shake(animatableData: shakeAnimationAmounts[number]))
                        .opacity(animateOpacity ? (number == correctAnswer ? 1 : 0.25) : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(animateUpdateScore ? (isCorrectAnswer ? .green : .red) : .white)
                    .font(.title.bold())
                    .animation(.linear(duration: Constants.scoreUpdateDuration))
                
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
    
    private func flagTapped(_ number: Int) {
        guard !isFlagSelected else {
            return
        }
        
        isFlagSelected = true
        animateOpacity = true
        animateUpdateScore = true
        
        if number == correctAnswer {
            score += 1
            isCorrectAnswer = true
            
            withAnimation(.spring(duration: Constants.flagAnimationDuration, bounce: 0.5)) {
                self.spinAnimationAmounts[number] += Constants.spinDegrees
            }
        } else {
            score -= 1
            isCorrectAnswer = false
            
            withAnimation(.easeInOut(duration: Constants.flagAnimationDuration)) {
                shakeAnimationAmounts[number] = Constants.shakes
            }
        }
        
        guard questionsCounter < 8 else {
            isGameOver = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.nextQuestionAfter) {
            askQuestion()
        }
    }
    
    private func askQuestion() {
        spinAnimationAmounts = [0.0, 0.0, 0.0]
        shakeAnimationAmounts = [0.0, 0.0, 0.0]
        animateUpdateScore = false
        animateOpacity = false
        isFlagSelected = false
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsCounter += 1
    }
    
    private func resetGame() {
        isGameOver = false
        score = 0
        questionsCounter = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
