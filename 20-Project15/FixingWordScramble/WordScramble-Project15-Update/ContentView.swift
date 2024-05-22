//
//  ContentView.swift
//  WordScramble
//
//  Created by Martin Ivanov on 4/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords: [String] = []
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private var score: Int {
        usedWords.reduce(0, {$0 + $1.count})
    }
    
    private let wordMinLenght = 3
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)
                    }
                    
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(word)")
                            .accessibilityHint("\(word.count) letters")
                        }
                    }
                }
                .navigationTitle(rootWord)
                .toolbar {
                    Button("New Game") {
                        startGame()
                    }
                }
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
            }
            
            Spacer()
            Text("Score: \(score)")
                .font(.title)
                .padding()
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        newWord = ""
        
        guard answer.count > 0 else { return }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Words must be at least \(wordMinLenght) letters long!")
            return
        }
        
        guard isNotRootWord(word: answer) else {
            wordError(title: "Root word", message: "You can't use the root word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
    }
    
    func startGame() {
        usedWords.removeAll()
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let startWords = try? String(contentsOf: startWordURL) {
            let allWords = startWords.components(separatedBy: "\n")
            rootWord = allWords.randomElement() ?? "silkworm"
            return
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isLongEnough(word: String) -> Bool {
        word.count > 3
    }
    
    func isNotRootWord(word: String) -> Bool {
        word != rootWord
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
