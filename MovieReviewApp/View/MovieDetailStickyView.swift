//
//  MovieDetailStickyView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/28.
//

import UIKit

class MovieDetailStickyView: UIView {
    
    private let backButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "test"
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private let shareButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .black
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
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        self.addSubview(shareButton)
        self.layer.addSublayer(bottomBorder)
    }
    
    private func autoLayoutSetting() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        backButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        shareButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        shareButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}
