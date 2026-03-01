//
//  AuthentificationHelperTests.swift
//  CashpadTests
//

import Testing
import UIKit
@testable import Cashpad

struct AuthentificationHelperTests {

    @MainActor
    @Test func doesNotAuthenticateWhenFaceIDDisabled() {
        let security = MockSecurityService()
        security.faceIDEnabled = false

        let helper = AppAuthenticationHelper(securityService: security)
        let window = UIWindow()

        helper.authenticateIfNeeded(window: window)

        // Window should remain interactive since Face ID is disabled
        #expect(window.isUserInteractionEnabled == true)
    }

    @MainActor
    @Test func authenticatesWhenFaceIDEnabled() {
        let security = MockSecurityService()
        security.faceIDEnabled = true
        security.authenticateResult = true

        let helper = AppAuthenticationHelper(securityService: security)
        let window = UIWindow()

        helper.authenticateIfNeeded(window: window)

        // After successful auth, window should be re-enabled
        #expect(window.isUserInteractionEnabled == true)
    }

    @MainActor
    @Test func failedAuthDisablesWindow() {
        let security = MockSecurityService()
        security.faceIDEnabled = true
        security.authenticateResult = false

        let helper = AppAuthenticationHelper(securityService: security)
        let window = UIWindow()

        helper.authenticateIfNeeded(window: window)

        // After failed auth, window should stay disabled
        #expect(window.isUserInteractionEnabled == false)
    }

    @MainActor
    @Test func resetSessionAllowsReauthentication() {
        let security = MockSecurityService()
        security.faceIDEnabled = true
        security.authenticateResult = true

        let helper = AppAuthenticationHelper(securityService: security)
        let window = UIWindow()

        // First auth succeeds
        helper.authenticateIfNeeded(window: window)
        #expect(window.isUserInteractionEnabled == true)

        // Second call should skip (already unlocked this session)
        helper.authenticateIfNeeded(window: window)
        #expect(window.isUserInteractionEnabled == true)

        // After reset, next call should trigger auth again
        helper.resetSession()
        security.authenticateResult = false
        helper.authenticateIfNeeded(window: window)
        #expect(window.isUserInteractionEnabled == false)
    }
}
