//
//  Question.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/27/24.
//

import Foundation

struct Question {
    var text: String
    var answer: String

    static func generateQuestions(for settings: Settings) -> [Question] {
        var questions: [Question] = []

        for i in 1...settings.tablesUpTo {
            for j in 1...12 {
                if j >= i {
                    let answer = String(i * j)
                    questions.append(Question(text: "\(i) x \(j) =", answer: answer))
                    if i != j {
                        questions.append(Question(text: "\(j) x \(i) =", answer: answer))
                    }
                }
            }
        }

        questions.shuffle()
        let questionsRange = 0..<settings.numberOfQuestions
        return Array(questions[questionsRange])
    }
}
