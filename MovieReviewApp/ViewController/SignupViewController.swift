//
//  SignupViewController.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/28.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController, FBAuthDatabase {

    let navigationBar: UINavigationBar = UINavigationBar()
    let nameTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "이름 (2글자 이상)"
        textField.textColor = .black
        textField.borderStyle = .none
        textField.tintColor = .systemPink
        textField.clearButtonMode = .always
        return textField
    }()
    let emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "이메일"
        textField.textColor = .black
        textField.borderStyle = .none
        textField.tintColor = .systemPink
        textField.clearButtonMode = .always
        return textField
    }()
    let passwordTextField: PasswordTextField = {
        let textField: PasswordTextField = PasswordTextField()
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "비밀번호"
        textField.textColor = .black
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .always
        return textField
    }()
    let footerView: UIView = UIView()
    let signupButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    var name: String = ""
    var email: String = ""
    var databaseManager: FBDataBaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        databaseManager = FBDataBaseManager()
        
        nameTextField.text = name
        emailTextField.text = email
        
        addNavigationBar()
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(footerView)
        footerView.addSubview(signupButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 10).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10).isActive = true
        signupButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        footerView.layoutIfNeeded()
        footerView.layer.addSublayer(addBorder(targetFrame: footerView.frame, position: .top))
        
        nameTextField.layoutIfNeeded()
        nameTextField.layer.addSublayer(addBorder(targetFrame: nameTextField.frame, position: .bottom))
        
        emailTextField.layoutIfNeeded()
        emailTextField.layer.addSublayer(addBorder(targetFrame: emailTextField.frame, position: .bottom))
        
        passwordTextField.layoutIfNeeded()
        passwordTextField.layer.addSublayer(addBorder(targetFrame: passwordTextField.frame, position: .bottom))
        passwordTextField.enablePasswordToggle()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
        
        signupButton.addTarget(self, action: #selector(SignupClick), for: .touchUpInside)
    }
    
    func addNavigationBar() {
        let safeAreaInsetsTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        
        navigationBar.frame = CGRect(x: 0, y: safeAreaInsetsTop, width: view.frame.width, height: safeAreaInsetsTop)
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .systemBackground
        let cancelItem: UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeClick))
        cancelItem.tintColor = .black
        let naviItem = UINavigationItem(title: "회원가입")
        naviItem.leftBarButtonItem = cancelItem
        
        navigationBar.items = [naviItem]
        
        view.addSubview(navigationBar)
    }
    
    func addBorder(targetFrame: CGRect, position: Position) -> CALayer {
        let border: CALayer = CALayer()
        switch position {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: targetFrame.width, height: 0.5)
        case .bottom:
            border.frame = CGRect(x: 0, y: targetFrame.height, width: targetFrame.width, height: 0.5)
        }
        
        border.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        return border
    }
    
    @objc func closeClick() {
        self.dismiss(animated: true)
    }
    
    @objc func SignupClick() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        FBAuth.createUserWithPassword(email: email, password: password) { result in
            switch result {
            case.success(_):
                FBAuth.signInWithPassword(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        self.setDatabaseProfile()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                FBAuth.signInWithPassword(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        self.setDatabaseProfile()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc func textChange() {
        guard let name = nameTextField.text,
           let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .systemPink
            return
        }
        signupButton.isEnabled = false
        signupButton.backgroundColor = .systemGray6
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
