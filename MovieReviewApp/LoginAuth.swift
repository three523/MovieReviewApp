//
//  LoginAuth.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/28.
//

import Foundation
import CryptoKit
import AuthenticationServices

protocol LoginNonce {
    var currentNonce: String? { get }
    func getRequest() -> ASAuthorizationAppleIDRequest
}

extension LoginNonce {
    public func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
          var result = ""
          var remainingLength = length

          while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
              var random: UInt8 = 0
              let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
              if errorCode != errSecSuccess {
                fatalError(
                  "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
              }
              return random
            }

            randoms.forEach { random in
              if remainingLength == 0 {
                return
              }

              if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
              }
            }
          }

          return result
    }
    
    @available(iOS 13, *)
    public func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

class LoginAuth: LoginNonce {
    var currentNonce: String?
    
    func getRequest() -> ASAuthorizationAppleIDRequest {
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        return request
    }
}
