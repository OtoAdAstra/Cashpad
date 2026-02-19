//
//  AppSecrets.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import Foundation

enum AppSecrets {

    static var exchangeApiKey: String {
        guard
            let key = Bundle.main.object(
                forInfoDictionaryKey: "EXCHANGE_API_KEY"
            ) as? String
        else {
            fatalError("EXCHANGE_API_KEY is missing")
        }
        return key
    }
}
