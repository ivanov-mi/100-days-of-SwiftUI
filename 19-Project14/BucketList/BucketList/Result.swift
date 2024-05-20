//
//  Result.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/20/24.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageId: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information."
    }
    
    private enum CodingKeys: String, CodingKey {
        case pageId = "pageid"
        case title
        case terms
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
