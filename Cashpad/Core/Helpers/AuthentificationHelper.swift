//
//  AuthentificationHelper.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 23.01.26.
//

import UIKit

final class AppAuthenticationHelper {

    private let securityService: SecurityServiceProtocol

    private var isAuthenticating = false
    private var isUnlockedThisSession = false

    init(securityService: SecurityServiceProtocol) {
        self.securityService = securityService
    }

    func authenticateIfNeeded(window: UIWindow) {
        guard securityService.isFaceIDEnabled else { return }
        guard !isAuthenticating else { return }
        guard !isUnlockedThisSession else { return }

        isAuthenticating = true
        window.isUserInteractionEnabled = false

        securityService.authenticate { [weak self] success in
            guard let self else { return }

            self.isAuthenticating = false

            if success {
                self.isUnlockedThisSession = true
                window.isUserInteractionEnabled = true
            } else {
                window.isUserInteractionEnabled = false
            }
        }
    }

    func resetSession() {
        isUnlockedThisSession = false
    }
}
