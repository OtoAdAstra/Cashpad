//
//  AccountRepositoryError.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 19.01.26.
//

import Foundation

enum AccountRepositoryError: Error, LocalizedError {
    case accountNotFound(id: UUID)

    var errorDescription: String? {
        switch self {
        case .accountNotFound(let id):
            return "Error not found account with id: \(id)"
        }
    }
}
