//
//  MultiplicationView.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/24/24.
//

import SwiftUI

struct MultiplicationView: View {
    @Bindable var settings: Settings
    @Binding var presentingMultiplication: Bool
    
    @State private var questions: [Question] = []
    @State private var currentQuestion = 0
    @State private var answer = ""
    @State private var gameInProgress = false
    @State private var score = 0
    
    @State private var animatingIncreaseScore = false
    @State private var animatingDecreaseScore = false
    
    private var questionsCounterText: String {
        "Question \(currentQuestion + 1)/\(questions.count) "
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.center) {
            
            Spacer()
            
            ZStack {
                HStack {
                    if gameInProgress {
                        Text(questions[currentQuestion].text)
                            .foregroundColor(.orange)
                        Text(answer.isEmpty ? "?" : answer)
                            .foregroundColor(.purple)
                    }
                    else {
                        Text("Score ")
                            .foregroundColor(.orange)
                        Text("\(score)/\(questions.count)")
                            .foregroundColor(.purple)
                    }
                }
                .font(.system(size: 64))
                
                Image(systemName: "hand.thumbsup")
                    .font(.system(size: 32))
                    .foregroundColor(animatingIncreaseScore ? .green : .clear)
                    .opacity(animatingIncreaseScore ? 0 : 1)
                    .offset(x: 0, y: animatingIncreaseScore ? -100 : -75)
                
                Image(systemName: "hand.thumbsdown")
                    .font(.system(size: 32))
                    .foregroundColor(animatingDecreaseScore ? .red : .clear)
                    .opacity(animatingDecreaseScore ? 0 : 1)
                    .offset(x: 0, y: animatingDecreaseScore ? 100 : 75)
            }
            
            if !gameInProgress {
                Button {
                    presentingMultiplication.toggle()
                } label: {
                    Text("New game")
                        .font(.title)
                        .padding()
                }
            }
            
            Spacer()
            
            Keyboard() { action in
                keyboardTapped(action: action)
            }
            .frame(height: 250)
        }
        .onAppear(perform: prepareNewGame)
        .toolbar {
            if gameInProgress {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentingMultiplication.toggle()
                    } label: {
                        Text("New game")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text(questionsCounterText)
                }
            }
        }
    }
    
    private func prepareNewGame() {
        questions = Question.generateQuestions(for: settings)
        currentQuestion = 0
        score = 0
        gameInProgress = true
    }
    
    private func keyboardTapped(action: KeyboardActions) {
        guard gameInProgress else { return }
        
        animatingIncreaseScore = false
        animatingDecreaseScore = false
        
        switch(action) {
        case .k0, .k1, .k2, .k3, .k4, .k5, .k6, .k7, .k8, .k9:
            if answer.count < 3 {
                answer += String(action.rawValue)
            }
        case .delete:
            if answer.count > 0 {
                answer.removeLast()
            }
        case .submit:
            guard !answer.isEmpty else { return }
            
            if questions[currentQuestion].answer == answer {
                score += 1
                
                withAnimation(Animation.linear(duration: 1)) {
                    animatingIncreaseScore = true
                }
            }
            else {
                withAnimation(Animation.linear(duration: 1)) {
                    animatingDecreaseScore = true
                }
            }
            
            answer = ""
            
            if currentQuestion >= questions.count - 1 {
                gameInProgress = false
            }
            
            currentQuestion += 1
        default:
            break
        }
    }
}

#Preview {
    @State var presentingMultiplication = false
    @State var settings = Settings()
    
    return MultiplicationView(settings: settings, presentingMultiplication: $presentingMultiplication)
}
