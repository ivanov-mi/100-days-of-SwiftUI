//
//  AuthenticationError.swift
//  BucketList
//
//  Created by Martin Ivanov on 5/21/24.
//

import Foundation

enum AuthenticationError: Error {
    case biometricsUnavailable
    case authenticationFailed(localizedDescription: String)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .biometricsUnavailable:
            return "Biometrics authentication unavailable"
        case .authenticationFailed(localizedDescription: let localizedDescription):
            return localizedDescription
        case .unknown:
            return "Unknown error"
        }
    }
}
