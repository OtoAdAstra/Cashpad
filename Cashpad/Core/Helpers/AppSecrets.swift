//
//  AppSecrets.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 22.01.26.
//

import Foundation
import os

enum AppSecrets {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Cashpad",
        category: "Secrets"
    )

    static var exchangeApiKey: String? {
        guard
            let key = Bundle.main.object(
                forInfoDictionaryKey: "EXCHANGE_API_KEY"
            ) as? String,
            !key.isEmpty
        else {
            logger.error("EXCHANGE_API_KEY is missing from Info.plist configuration")
            return nil
        }
        return key
    }
}
