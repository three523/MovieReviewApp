//
//  LoginViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/09/19.
//

import UIKit
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

//MARK: 동일한 이메일로 가입한 경우 예외 처리

class AuthViewController: UIViewController, FBAuthDatabase {
    
    let logoView: UIView = UIView()
    let logoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "MovieReview"
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textColor = .white
        return label
    }()
    let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "TMDB에서 영화나 드라마를 추천받고 \n리뷰를 보거나 직접 남겨보세요"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let loginButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        return btn
    }()
    
    let containerView: UIView = UIView()
    let signStackView: UIStackView = {
        let st: UIStackView = UIStackView()
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fillEqually
        st.spacing = 10
        return st
    }()
    let appleLoginButton: LoginButton = {
        let button: LoginButton = LoginButton()
        button.setTitle("Apple로 계속하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.setImage(UIImage(named: "AppleLoginLogo"), for: .normal)
        button.backgroundColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    //MARK: 카카오 로고 이미지는 깨지는 관계로 변경의 필요성이 있음
    let kakaoLoginButton: LoginButton = {
        let button: LoginButton = LoginButton()
        button.setTitle("카카오로 계속하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        button.backgroundColor = UIColor(rgb: 0xFEE500)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    let otherButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("옵션 더 보기", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.systemGray5, for: .highlighted)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return btn
    }()
    var databaseManager: FBDataBaseManager?
    var name: String = "Guest"
    
    var currentNonce: String?
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.dismiss(animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseManager = FBDataBaseManager()

        logoView.backgroundColor = .systemPink
        
        logoView.addSubview(loginButton)
        logoView.addSubview(logoLabel)
        logoView.addSubview(descriptionLabel)
        
        containerView.addSubview(signStackView)
        
        view.addSubview(logoView)
        view.addSubview(containerView)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        loginButton.addAction(UIAction(handler: { _ in
            let loginVC: UIViewController = LoginViewController()
            loginVC.modalPresentationStyle = .overFullScreen
            self.present(loginVC, animated: true)
        }), for: .touchUpInside)
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: logoView.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        signStackView.translatesAutoresizingMaskIntoConstraints = false
        signStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        signStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        signStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        
        signStackView.addArrangedSubview(appleLoginButton)
        appleLoginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        appleLoginButton.layoutIfNeeded()
        guard let appleLogoView = appleLoginButton.imageView else { return }
        
        appleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: appleLoginButton.frame.width - appleLogoView.frame.height)
        
        appleLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -round(appleLogoView.frame.width+5), bottom: 0, right: 0)
        appleLoginButton.addTarget(self, action: #selector(clickAppleLogin), for: .touchUpInside)
        
        signStackView.addArrangedSubview(kakaoLoginButton)
        signStackView.layoutIfNeeded()
        kakaoLoginButton.layoutIfNeeded()
        guard let kakaoLogoView = kakaoLoginButton.imageView else { return }
        kakaoLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: (kakaoLoginButton.frame.width - kakaoLogoView.frame.width) - 10)
        
        kakaoLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -kakaoLogoView.frame.width, bottom: 0, right: 0)
        kakaoLoginButton.addTarget(self, action: #selector(clickKakaoLogin), for: .touchUpInside)
        
        signStackView.addArrangedSubview(otherButton)
        otherButton.addAction(UIAction(handler: { _ in
            let otherLoginVC: UIViewController = OtherLoginViewController()
            otherLoginVC.modalPresentationStyle = .overFullScreen
            self.present(otherLoginVC, animated: false)
        }), for: .touchUpInside)
        
    }
   
    @objc func clickAppleLogin() {
        
        let nonce = FBAuth.randomNonceString()
        currentNonce = nonce
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = FBAuth.sha256(nonce)
        
        let appleAuthVC = ASAuthorizationController(authorizationRequests: [request])
        appleAuthVC.delegate = self
        appleAuthVC.presentationContextProvider = self
        appleAuthVC.performRequests()
    }
    
    @objc func clickKakaoLogin() {
        let signupVC: SignupViewController = SignupViewController()
        signupVC.modalPresentationStyle = .fullScreen
        
        let nonce = FBAuth.randomNonceString()
        currentNonce = nonce
        if UserApi.isKakaoTalkLoginAvailable() {
            FBAuth.signInWithKakaoTalk(nonce: nonce) { result in
                switch result {
                case .success(let user):
                    let username = user.kakaoAccount?.profile?.nickname ?? ""
                    let email = user.kakaoAccount?.email ?? ""
                    signupVC.name = username
                    signupVC.email = email
                    
                    self.present(signupVC, animated: false)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            FBAuth.signInWithKakao { result in
                switch result {
                case .success(let user):
                    let username = user.kakaoAccount?.profile?.nickname ?? ""
                    let email = user.kakaoAccount?.email ?? ""
                    signupVC.name = username
                    signupVC.email = email
                    
                    self.present(signupVC, animated: false)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idToken = appleIDCredential.identityToken,
                  let tokenStr = String(data: idToken, encoding: .utf8) else { return }
                                    
            guard let nonce = currentNonce else { return }
            
            if let familyName = appleIDCredential.fullName?.familyName,
               let givenName = appleIDCredential.fullName?.givenName {
                name = familyName + givenName
            }
            
            FBAuth.signInWithApple(idTokenString: tokenStr, nonce: nonce) { result in
                switch result {
                case .success(_):
                    self.setDatabaseProfile()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
