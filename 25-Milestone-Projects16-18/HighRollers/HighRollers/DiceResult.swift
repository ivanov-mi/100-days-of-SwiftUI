//
//  DiceResult.swift
//  HighRollers
//
//  Created by Martin Ivanov on 6/18/24.
//

import Foundation

struct DiceResult: Codable, Identifiable {
    let id: UUID
    var type: Int
    var number: Int
    var rolls: [Int] = []
    
    var description: String {
        rolls.map(String.init).joined(separator: ", ")
    }
     
    init(type: Int, number: Int) {
        self.id = UUID()
        self.type = type
        self.number = number
        
        for _ in 0..<number {
            rolls.append(Int.random(in: 1...type))
        }
    }
}
