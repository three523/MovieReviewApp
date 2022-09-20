//
//  LoginViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/09/19.
//

import UIKit

enum Position {
    case top,bottom
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    let navigationBar: UINavigationBar = UINavigationBar()
    let emaliTextField: UITextField = {
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
    let forgotPasswordButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
        button.setTitleColor(UIColor.systemPink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    let loginButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        button.backgroundColor = .systemGray5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addNavigationBar()
        
        view.addSubview(emaliTextField)
        view.addSubview(passwordTextField)
        view.addSubview(footerView)
        footerView.addSubview(forgotPasswordButton)
        footerView.addSubview(loginButton)
        
        emaliTextField.translatesAutoresizingMaskIntoConstraints = false
        emaliTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 10).isActive = true
        emaliTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        emaliTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emaliTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emaliTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10).isActive = true
        forgotPasswordButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        footerView.layoutIfNeeded()
        footerView.layer.addSublayer(addBorder(targetFrame: footerView.frame, position: .top))
        
        emaliTextField.layoutIfNeeded()
        emaliTextField.layer.addSublayer(addBorder(targetFrame: emaliTextField.frame, position: .bottom))
        
        passwordTextField.layoutIfNeeded()
        passwordTextField.layer.addSublayer(addBorder(targetFrame: passwordTextField.frame, position: .bottom))
        passwordTextField.enablePasswordToggle()
        
        emaliTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func addNavigationBar() {
        let safeAreaInsetsTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        
        navigationBar.frame = CGRect(x: 0, y: safeAreaInsetsTop, width: view.frame.width, height: safeAreaInsetsTop)
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .systemBackground
        let cancelItem: UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeClick))
        cancelItem.tintColor = .black
        let naviItem = UINavigationItem(title: "로그인")
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

}

class PasswordTextField: UITextField {
    
    override var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry { return }
            secureTextEntryisTure()
        }
    }
    
    func secureTextEntryisTure() {
        if !isSecureTextEntry { return }

        if let currentText = text {
            let currentPosition = selectedTextRange
            insertText(currentText)
            selectedTextRange = currentPosition
        }
    }
    
    private func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }

    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        let buttonSize: CGFloat = 25
        setPasswordToggleImage(button)

        button.frame = CGRect(x: self.frame.size.width - buttonSize, y: (self.frame.size.height - buttonSize)/2, width: buttonSize, height: buttonSize)
        button.tintColor = .systemGray3
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        addSubview(button)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let buttonSize: CGFloat = 25
        let buttonPadding: CGFloat = 10
        return CGRect(x: self.frame.size.width - (buttonSize + buttonSize + buttonPadding), y: (self.frame.size.height - buttonSize)/2, width: buttonSize, height: buttonSize)
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}
