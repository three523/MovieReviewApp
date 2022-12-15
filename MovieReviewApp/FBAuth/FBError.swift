//
//  FBError.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/28.
//

import Foundation

enum FBDatabaseManagerError: Error {
    case snapShotNil
    case emailNil
}

extension FBDatabaseManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .snapShotNil:
            return NSLocalizedString("SnapShot is nil", comment: "")
        case .emailNil:
            return NSLocalizedString("Current email is nil", comment: "")
        }
    }
}

enum SignInWithAppleAuthError: Error {
    case noAuthDataResult
    case noIdentityToken
    case noIdTokenString
    case noAppleIDCredential
}

extension SignInWithAppleAuthError: LocalizedError {
    // This will provide me with a specific localized description for the SignInWithAppleAuthError
    var errorDescription: String? {
        switch self {
        case .noAuthDataResult:
            return NSLocalizedString("No Auth Data Result", comment: "")
        case .noIdentityToken:
            return NSLocalizedString("Unable to fetch identity token", comment: "")
        case .noIdTokenString:
            return NSLocalizedString("Unable to serialize token string from data", comment: "")
        case .noAppleIDCredential:
            return NSLocalizedString("Unable to create Apple ID Credential", comment: "")
        }
    }
}

enum SignInWithKakaoAuthError: Error {
    case noAuthUserData
}

extension SignInWithKakaoAuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case.noAuthUserData:
            return NSLocalizedString("No Auth Data User", comment: "")
        }
    }
}
