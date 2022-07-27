//
//  MovieDetailHeaderView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/27.
//

import UIKit

class MovieDetailHeaderView: UIView {
    
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var imageViewHeight: NSLayoutConstraint = NSLayoutConstraint()
    private var imageViewBottom: NSLayoutConstraint = NSLayoutConstraint()
    private var containerView: UIView = UIView()
    private var containerViewHeight: NSLayoutConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        setViewConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    private func setViewConstraint() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
}
