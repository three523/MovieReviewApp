//
//  CircleIconImageView.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/19.
//

import UIKit

class CircleIconImageView: UIView {
    
    private let imageView: UIImageView = UIImageView()
    private var imageSize: CGFloat = 30
    private var inset: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage?, imageSize: CGFloat = 30, inset: CGFloat) {
        self.init()
        self.imageSize = imageSize
        self.inset = inset
        
        self.backgroundColor = .systemGray6
        self.clipsToBounds = true
        imageView.image = image
        imageView.backgroundColor = .systemGray6
        imageView.tintColor = .systemGray3
        
        viewAdd()
        autoLayoutSetting()

    }
    
    private func viewAdd() {
        self.addSubview(imageView)
    }
    
    private func autoLayoutSetting() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset).isActive = true
        let imageHeightAnchor = imageView.heightAnchor.constraint(equalToConstant: imageSize)
        imageHeightAnchor.priority = UILayoutPriority(999)
        imageHeightAnchor.isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset).isActive = true
    }
    
    public func setImageCircle() {
        self.layoutIfNeeded()
        print(imageSize,inset)
        self.layer.cornerRadius = (imageSize + inset*2)/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
