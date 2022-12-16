//
//  AuthServices.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/26.
//

//import Foundation
//import AuthenticationServices
//
//protocol LoginManagerDelegate: AnyObject {
//    
//}
//
//final class LoginManager: NSObject {
//    weak var vc: UIViewController?
//    weak var delegate: LoginManagerDelegate?
//    
//    func setAppleLoginPresentationAnchorView(_ vc: UIViewController) {
//        self.vc = vc
//    }
//}
//
//extension LoginManager: ASAuthorizationControllerPresentationContextProviding {
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        guard let presentationAnchor = vc?.view.window else { return ASPresentationAnchor() }
//        return presentationAnchor
//    }
//    
//}
