//
//  CardViewModel.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/6/24.
//

import Foundation

struct CardViewModel {
    let id: UUID
    var prompt: String
    var answer: String
    var showAnswer: Bool
    
    init(card: Card, showAnswer: Bool = false) {
        self.id = card.id
        self.prompt = card.prompt
        self.answer = card.answer
        self.showAnswer = showAnswer
    }
}
