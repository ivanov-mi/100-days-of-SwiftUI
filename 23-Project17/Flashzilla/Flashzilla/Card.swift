//
//  Card.swift
//  Flashzilla
//
//  Created by Martin Ivanov on 6/3/24.
//

import Foundation
import SwiftData

@Model
class Card: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case prompt
        case answer
    }
    
    let id: UUID
    var prompt: String
    var answer: String
    
    init(id: UUID = UUID(), prompt: String, answer: String) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        prompt = try container.decode(String.self, forKey: .prompt)
        answer = try container.decode(String.self, forKey: .answer)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(answer, forKey: .answer)
    }
}
