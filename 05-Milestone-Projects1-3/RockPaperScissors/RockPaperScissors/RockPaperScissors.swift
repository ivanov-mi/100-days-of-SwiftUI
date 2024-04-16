//
//  RockPaperScissors.swift
//  RockPaperScissors
//
//  Created by Martin Ivanov on 4/16/24.
//

import Foundation

enum Shape: CaseIterable, Identifiable {
    var id: Self {
        self
    }
    
    case rock
    case paper
    case scissors
    
    var symbol: String {
        switch self {
        case .rock:
            return "✊"
        case .paper:
            return "✋"
        case .scissors:
            return "✌️"
        }
    }
}

enum Goal: String, CaseIterable {
    case win = "win"
    case lose = "lose"
}

struct RockPaperScissors {
    let gameSelection: Shape = Shape.allCases.randomElement()!
    let goal: Goal = Goal.allCases.randomElement()!
    
    func shouldWin(shape userSelection: Shape) -> Bool {
        switch(goal, userSelection, gameSelection) {
        case (.win, .rock, .scissors),
            (.win, .scissors, .paper),
            (.win, .paper, .rock), 
            (.lose, .rock, .paper),
            (.lose, .scissors, .rock),
            (.lose, .paper, .scissors):
            return true
        default:
            return false
        }
    }
}
