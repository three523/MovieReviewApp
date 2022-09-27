//
//  LoginButton.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/09/27.
//

import UIKit

class LoginButton: UIButton {
    
    func moveImageLeftTextCenter(imagePadding: CGFloat = 30.0){
            guard let imageViewWidth = self.imageView?.frame.width else{return}
            guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else{return}
            self.contentHorizontalAlignment = .left
            imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imagePadding - imageViewWidth / 2, bottom: 0.0, right: 0.0)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
        }

}
