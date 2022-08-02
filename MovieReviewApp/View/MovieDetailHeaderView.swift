//
//  MovieDetailHeaderView.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/27.
//

import UIKit

class MovieDetailHeaderView: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let posterImageView: UIImageView = UIImageView()
    private let movieTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "test"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let moviesubTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "testtest"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private var imageViewHeight: NSLayoutConstraint = NSLayoutConstraint()
    private var imageViewBottom: NSLayoutConstraint = NSLayoutConstraint()
    private var containerView: UIView = UIView()
    private var subviewsContainerView: UIView = UIView()
    private var containerViewHeight: NSLayoutConstraint = NSLayoutConstraint()
    private var subviewsAlpha: Double = 1
    
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
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(subviewsContainerView)
        subviewsContainerView.addSubview(posterImageView)
        subviewsContainerView.addSubview(movieTitleLabel)
        subviewsContainerView.addSubview(moviesubTitleLabel)
    }
    
    private func setViewConstraint() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        posterImageView.image = UIImage(systemName: "person")
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = backgroundImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        subviewsContainerView.translatesAutoresizingMaskIntoConstraints = false
        subviewsContainerView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 10).isActive = true
        subviewsContainerView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10).isActive = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.leadingAnchor.constraint(equalTo: subviewsContainerView.leadingAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: subviewsContainerView.bottomAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        
        moviesubTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        moviesubTitleLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 10).isActive = true
        moviesubTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        moviesubTitleLabel.bottomAnchor.constraint(equalTo: subviewsContainerView.bottomAnchor).isActive = true
    }
    
    func setImage(backgroundImage: UIImage?, moviePosterImage: UIImage?) {
        DispatchQueue.main.async {
            self.backgroundImageView.image = backgroundImage
            self.posterImageView.image = moviePosterImage
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
//        imageViewHeight.constant = offsetY >= 0 ? offsetY : 0
        if offsetY <= 0 {
            subviewsContainerView.alpha = 1
        } else if offsetY > 0 {
            subviewsContainerView.alpha = 1 - offsetY / 100
        }
    }
    
}
