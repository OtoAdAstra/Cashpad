//
//  SecurityService.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 23.01.26.
//

import LocalAuthentication
import SwiftUI

protocol SecurityServiceProtocol {
    var isFaceIDEnabled: Bool { get }
    func setFaceID(_ enabled: Bool)
    func authenticate(completion: @escaping (Bool) -> Void)
}

final class SecurityService: SecurityServiceProtocol {

    @AppStorage("requireFaceID")
    private var requireFaceID: Bool = false

    var isFaceIDEnabled: Bool {
        requireFaceID
    }

    func setFaceID(_ enabled: Bool) {
        requireFaceID = enabled
    }

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        ) else {
            completion(false)
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: "Unlock Cashpad"
        ) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
