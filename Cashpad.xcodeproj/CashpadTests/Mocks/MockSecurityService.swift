//
//  MockSecurityService.swift
//  CashpadTests
//

import Foundation
@testable import Cashpad

final class MockSecurityService: SecurityServiceProtocol {

    var faceIDEnabled = false
    var authenticateResult = true

    var isFaceIDEnabled: Bool { faceIDEnabled }

    func setFaceID(_ enabled: Bool) {
        faceIDEnabled = enabled
    }

    func authenticate(completion: @escaping (Bool) -> Void) {
        completion(authenticateResult)
    }
}
