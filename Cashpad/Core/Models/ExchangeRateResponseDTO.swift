//
//  ExchangeRateResponseDTO.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 21.01.26.
//


import Foundation

struct ExchangeRateResponseDTO: Decodable {
    let data: [String: Double]
}