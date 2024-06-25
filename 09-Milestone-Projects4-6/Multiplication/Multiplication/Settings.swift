//
//  Settings.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/25/24.
//

import Foundation

enum QuestionsNumberOptions: Int, CaseIterable {
    case five = 5
    case ten = 10
    case twenty = 20
}

enum MultiplicationTablesBounds: Int {
    case min = 2
    case max = 12
    
    static func maxRange() -> ClosedRange<Int> {
        Self.min.rawValue...Self.max.rawValue
    }
}

@Observable
class Settings {
    var tablesUpTo: Int
    var numberOfQuestions: Int
    
    init(tablesUpTo: Int = MultiplicationTablesBounds.min.rawValue, numberOfQuestions: Int = QuestionsNumberOptions.five.rawValue) {
        self.tablesUpTo = tablesUpTo
        self.numberOfQuestions = numberOfQuestions
    }
}
