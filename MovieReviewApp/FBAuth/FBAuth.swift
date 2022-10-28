//
//  FBAuth.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/28.
//

import FirebaseAuth
import CryptoKit
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon


struct FBAuth {
    static func authenticate(authCredential: AuthCredential, completed: @escaping(Result<Bool,Error>) -> ()) {
        Auth.auth().signIn(with: authCredential) { (authResult, error) in
            if let error = error {
                completed(.failure(error))
            } else {
                completed(.success(true))
            }
        }
    }
    
    static func signInWithKakao(completion: @escaping (Result<KakaoSDKUser.User,Error>) -> ()) {
        
        UserApi.shared.loginWithKakaoAccount { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                UserApi.shared.me() { (user, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        if let user = user {
                            let nonce = randomNonceString()
                            var scopes = [String]()
                            if user.kakaoAccount?.profileNeedsAgreement == true { scopes.append("profile") }
                            if user.kakaoAccount?.nameNeedsAgreement == true { scopes.append("name") }
                            if user.kakaoAccount?.emailNeedsAgreement == true { scopes.append("account_email") }
                            scopes.append("openid")
                            
                            if scopes.count > 0 {
                                UserApi.shared.loginWithKakaoAccount(scopes: scopes, nonce: nonce) { _, error in
                                    if let error = error {
                                        completion(.failure(error))
                                    } else {
                                        UserApi.shared.me { user, error in
                                            if let error = error {
                                                completion(.failure(error))
                                            } else {
                                                guard let user = user else {
                                                    completion(.failure(SignInWithKakaoAuthError.noAuthUserData))
                                                    return
                                                }
                                                completion(.success(user))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    static func signInWithApple(idTokenString: String, nonce: String, completion: @escaping (Result<AuthDataResult,Error>) -> ()) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (authDataResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                guard let authDataResult = authDataResult else {
                    completion(.failure(SignInWithAppleAuthError.noAuthDataResult))
                    return
                }
                completion(.success(authDataResult))
            }
        }
    }
    
    static func reauthenticateWithApple(idTokenString: String, nonce: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, accessToken: nonce)
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    static func deleteUser(completion: @escaping (Result<Bool,Error>) -> ()) {
        if let user = Auth.auth().currentUser {
            user.delete() { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
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
    
    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    static func logout(completion: @escaping (Result<Bool,Error>) -> ()) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
        }
    }
}
