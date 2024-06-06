//
//  Card.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/3/24.
//

import Foundation

struct Card: Identifiable, Codable {
    let id: UUID
    var prompt: String
    var answer: String
    
    static let example = Card(id: UUID(), prompt: "Who player the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
