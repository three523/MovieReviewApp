//
//  MovieCommentViewController.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/17.
//

import UIKit

class MovieCommentViewController: UIViewController {
    
    let topCommentView: CustomNavigationBar = CustomNavigationBar()
    let textViewPlaceHolder: String = "작품에 대한 생각을 자유롭게 적어주세요."
    let placeHolderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .lightGray
        label.text = "작품에 대한 생각을 자유롭게 적어주세요."
        label.font = .italicSystemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    lazy var commentTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.delegate = self
        textView.font = .systemFont(ofSize: placeHolderLabel.font.pointSize)
        textView.textColor = .lightGray
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.frame.origin = CGPoint(x: 25, y: placeHolderLabel.font.pointSize/2 + 12)
        return textView
    }()
    let bottomHeader: UIView = UIView()
    var isSpoiler: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(topCommentView)
        view.addSubview(commentTextView)
        view.addSubview(bottomHeader)
        
        commentTextView.becomeFirstResponder()
        commentTextView.selectedTextRange = commentTextView.textRange(from: commentTextView.beginningOfDocument, to: commentTextView.beginningOfDocument)
        
        topCommentViewSetting()
        autolayoutSetting()
        bottomHeaderSetting()
    }
    
    private func bottomHeaderSetting() {
        
        let toggle: UISwitch = UISwitch()
        toggle.isOn = isSpoiler

        toggle.addAction(UIAction(handler: { _ in
            self.isSpoiler = !self.isSpoiler
        }), for: .valueChanged)
        
        let toggleLabel: UILabel = UILabel()
        toggleLabel.text = "스포일러"
        
        let shareLabel: UILabel = UILabel()
        shareLabel.text = "공유"
        
        let shareButton: UIButton = UIButton()
        shareButton.setImage(UIImage(systemName: "ant.fill"), for: .normal)
        shareButton.tintColor = .lightGray
        
        bottomHeader.addSubview(toggle)
        bottomHeader.addSubview(toggleLabel)
        bottomHeader.addSubview(shareLabel)
        bottomHeader.addSubview(shareButton)
        
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.centerYAnchor.constraint(equalTo: bottomHeader.centerYAnchor).isActive = true
        toggle.leadingAnchor.constraint(equalTo: bottomHeader.leadingAnchor, constant: 20).isActive = true
        
        toggleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleLabel.centerYAnchor.constraint(equalTo: bottomHeader.centerYAnchor).isActive = true
        toggleLabel.leadingAnchor.constraint(equalTo: toggle.trailingAnchor, constant: 10).isActive = true
        
        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.centerYAnchor.constraint(equalTo: bottomHeader.centerYAnchor).isActive = true
        shareLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -10).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.topAnchor.constraint(equalTo: bottomHeader.topAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: bottomHeader.trailingAnchor, constant: -20).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: bottomHeader.bottomAnchor).isActive = true
        
        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.opacity = 0.5
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        
        bottomHeader.layer.addSublayer(layer)
    }
    
    private func topCommentViewSetting() {
        topCommentView.isSticky = true
        topCommentView.setMainTitle(title: "코멘트 작성")
        topCommentView.leftButtonPadding(insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        topCommentView.leftButtonSetTitle(title: "취소")
        let dismissAction: UIAction = UIAction{ _ in self.dismiss(animated: true) }
        topCommentView.leftButtonAction(action: dismissAction)
        topCommentView.rightButtonPadding(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        topCommentView.rightButtonSetTitle(title: "확인")
        let completeAction: UIAction = UIAction{ _ in self.dismiss(animated: true) }
        topCommentView.rightButtonAction(action: completeAction)
    }
    
    private func autolayoutSetting() {
        topCommentView.translatesAutoresizingMaskIntoConstraints = false
        topCommentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topCommentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topCommentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topCommentView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.topAnchor.constraint(equalTo: topCommentView.bottomAnchor).isActive = true
        commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomHeader.translatesAutoresizingMaskIntoConstraints = false
        bottomHeader.topAnchor.constraint(equalTo: commentTextView.bottomAnchor).isActive = true
        bottomHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomHeader.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        bottomHeader.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

extension MovieCommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
}
