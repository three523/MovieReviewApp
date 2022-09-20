//
//  LoginViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/09/19.
//

import UIKit

class AuthViewController: UIViewController {
    
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
    let otherButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("옵션 더 보기", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.systemGray5, for: .highlighted)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        signStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        signStackView.addArrangedSubview(otherButton)
        otherButton.addAction(UIAction(handler: { _ in
            let otherLoginVC: UIViewController = OtherLoginViewController()
            otherLoginVC.modalPresentationStyle = .overFullScreen
            self.present(otherLoginVC, animated: false)
        }), for: .touchUpInside)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
