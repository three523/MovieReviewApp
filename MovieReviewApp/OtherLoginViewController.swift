//
//  LoginViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/09/19.
//

import UIKit

class OtherLoginViewController: UIViewController {

    let headerView: UIView = UIView()
    let headerMainLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "시작하기"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    let headerSubButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        return btn
    }()
    let popupView: UIView = UIView()
    var popupViewHeightAnchor: NSLayoutConstraint? = nil
    var initPopupViewHeightConstraint: CGFloat? = nil
    var initialTouchPointY: CGFloat? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.addSubview(popupView)
        popupView.addSubview(headerView)
        headerView.addSubview(headerMainLabel)
        headerView.addSubview(headerSubButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10).isActive = true
        headerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 10).isActive = true
        headerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -10).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headerMainLabel.translatesAutoresizingMaskIntoConstraints = false
        headerMainLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        headerMainLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        headerSubButton.translatesAutoresizingMaskIntoConstraints = false
        headerSubButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerSubButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        
        headerSubButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: false)
        }), for: .touchUpInside)
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(popupViewTouch))
        
        popupView.addGestureRecognizer(panGesture)
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 20
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        popupViewHeightAnchor = popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        popupViewHeightAnchor?.isActive = true
        initPopupViewHeightConstraint = popupViewHeightAnchor?.constant
    }
    
    @objc func popupViewTouch(_ gesture: UIPanGestureRecognizer) {
        guard let popupView = gesture.view else { return }
        if gesture.state == .began {
            self.initialTouchPointY = gesture.location(in: popupView).y
        }
        
        if gesture.state == .changed {
            let changedY = gesture.location(in: popupView).y
            popupHeight(changedY: changedY)
        }
        
        if gesture.state == .ended {
            let endedY = gesture.location(in: popupView).y
            popupHeight(changedY: endedY)
            checkPopupViewHeight()
        }
    }
    
    func popupHeight(changedY: CGFloat) {
        guard let initTocuhPointY = initialTouchPointY ,
            let heightAnchor = popupViewHeightAnchor else { return }
        let minHeight: CGFloat = (view.frame.height/2) - 150
        let result = initTocuhPointY - changedY
        heightAnchor.constant += result
        if popupView.frame.height <= minHeight { self.dismiss(animated: false) }
    }
    
    func checkPopupViewHeight() {
        guard let initPopupViewHeightConstraint = initPopupViewHeightConstraint else { return }
        let maxHeight: CGFloat = view.frame.height/2
        let minHeight: CGFloat = maxHeight - 100
        
        self.popupViewHeightAnchor?.constant = initPopupViewHeightConstraint
        
        if popupView.frame.height > maxHeight {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.view.layoutIfNeeded()
            }
        }
        if popupView.frame.height <= minHeight { self.dismiss(animated: false) }
    }

}
