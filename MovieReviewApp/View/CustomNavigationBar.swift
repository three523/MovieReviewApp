//
//  MovieDetailStickyView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/28.
//

import UIKit

class CustomNavigationBar: UIView {
    
    private let leftButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.tintColor = .black
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private let rightButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.tintColor = .black
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    private let bottomBorder: CALayer = {
        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.opacity = 0.5
        layer.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 0.5)
        layer.isHidden = true
        return layer
    }()
    
    var isSticky: Bool = false {
        willSet {
            titleLabel.isHidden = !newValue
            bottomBorder.isHidden = !newValue
            self.backgroundColor = newValue ? .white : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        addViews()
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        self.layer.addSublayer(bottomBorder)
        
        print(titleLabel.isHidden)
    }
    
    private func autoLayoutSetting() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        leftButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        rightButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    public func setMainTitle(title: String) {
        titleLabel.text = title
    }
    
    public func leftButtonSetImage(image: UIImage) {
        leftButton.setImage(image, for: .normal)
    }
    
    public func rightButtonSetImage(image: UIImage) {
        rightButton.setImage(image, for: .normal)
    }
    
    public func leftButtonSetTitle(title: String) {
        leftButton.setTitle(title, for: .normal)
    }
    
    public func rightButtonSetTitle(title: String) {
        rightButton.setTitle(title, for: .normal)
    }
    
    public func leftButtonAction(action: UIAction) {
        leftButton.addAction(action, for: .touchUpInside)
    }
    
    public func rightButtonAction(action: UIAction) {
        rightButton.addAction(action, for: .touchUpInside)
    }
    
    public func leftButtonPadding(insets: UIEdgeInsets){
        leftButton.contentEdgeInsets = insets
    }
    
    public func rightButtonPadding(insets: UIEdgeInsets) {
        rightButton.contentEdgeInsets = insets
    }
    
    public func isStickyEnable(enable: Bool) {
        if !enable {
            titleLabel.isHidden = false
            bottomBorder.isHidden = false
        }
    }
}
