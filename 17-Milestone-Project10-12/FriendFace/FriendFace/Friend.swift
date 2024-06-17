//
//  Friend.swift
//  FriendFace
//
//  Created by Martin Ivanov on 6/17/24.
//

import Foundation

struct Friend: Hashable, Identifiable, Codable {
    let id: UUID
    var name: String
}
