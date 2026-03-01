//
//  ExchangeRateResponseDTOTests.swift
//  CashpadTests
//

import Testing
import Foundation
@testable import Cashpad

struct ExchangeRateResponseDTOTests {

    @Test func decodesValidJSON() throws {
        let json = """
        {
            "data": {
                "USD": 1.0,
                "EUR": 0.85,
                "GBP": 0.73
            }
        }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ExchangeRateResponseDTO.self, from: json)
        #expect(dto.data["USD"] == 1.0)
        #expect(dto.data["EUR"] == 0.85)
        #expect(dto.data["GBP"] == 0.73)
        #expect(dto.data.count == 3)
    }

    @Test func decodesEmptyData() throws {
        let json = """
        { "data": {} }
        """.data(using: .utf8)!

        let dto = try JSONDecoder().decode(ExchangeRateResponseDTO.self, from: json)
        #expect(dto.data.isEmpty)
    }
}
