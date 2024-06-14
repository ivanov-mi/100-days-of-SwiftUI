//
//  Sequence+Extension.swift
//  SnowSeeker
//
//  Created by Martin Ivanov on 6/14/24.
//

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
