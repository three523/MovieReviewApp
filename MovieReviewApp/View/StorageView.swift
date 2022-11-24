//
//  StorageView.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/19.
//

import UIKit

class StorageView: UIView {

    private var imageView: CircleIconImageView
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = ""
        return label
    }()
    var imageInset: CGFloat = 10
    
    override init(frame: CGRect) {
        imageView = CircleIconImageView(image: UIImage(systemName: "x.circle.fill"), inset: imageInset)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage?, imageSize: CGFloat, inset: CGFloat, text: String) {
        self.init()
        imageView = CircleIconImageView(image: image, imageSize: imageSize, inset: inset)
        titleLabel.text = text
        
        viewAdd()
        autoLayoutSetting()
    }
    
    private func viewAdd() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
    
    private func autoLayoutSetting() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        let titleBottomAnchor = titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        titleBottomAnchor.priority = UILayoutPriority(999)
        titleBottomAnchor.isActive = true
    }
    
    public func setImageCircle() {
        imageView.setImageCircle()
    }
    
}
