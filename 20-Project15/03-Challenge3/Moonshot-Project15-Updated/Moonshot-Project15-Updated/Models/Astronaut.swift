//
//  Astronaut.swift
//  Moonshot
//
//  Created by Martin Ivanov on 4/25/24.
//

import Foundation

struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}
