//
//  String+Utilities.swift
//  CupcakeCorner
//
//  Created by Martin Ivanov on 4/30/24.
//

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
