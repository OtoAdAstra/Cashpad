//
//  AccountModel.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 12.01.26.
//


import Foundation

struct AccountModel: Identifiable, Hashable {

    let id: UUID
    let name: String
    let currency: String
    let emoji: String?
    let color: String?
    let createdAt: Date

    let balance: Double
}
