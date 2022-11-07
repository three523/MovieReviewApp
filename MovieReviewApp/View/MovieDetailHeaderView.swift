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
    private let gradientView: UIView = UIView()
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
        label.numberOfLines = 0
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
        backgroundImageGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientView)
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
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
        subviewsContainerView.translatesAutoresizingMaskIntoConstraints = false
        subviewsContainerView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 10).isActive = true
        subviewsContainerView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -10).isActive = true
        subviewsContainerView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10).isActive = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.topAnchor.constraint(equalTo: subviewsContainerView.topAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: subviewsContainerView.leadingAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: subviewsContainerView.bottomAnchor).isActive = true
        let posterImageHeight = posterImageView.heightAnchor.constraint(equalToConstant: 160)
        posterImageHeight.priority = UILayoutPriority(999)
        posterImageHeight.isActive = true
        let posterImageWidth = posterImageView.widthAnchor.constraint(equalToConstant: 80)
        posterImageWidth.priority = UILayoutPriority(999)
        posterImageWidth.isActive = true
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        
        moviesubTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        moviesubTitleLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 10).isActive = true
        moviesubTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        moviesubTitleLabel.trailingAnchor.constraint(equalTo: subviewsContainerView.trailingAnchor).isActive = true
        moviesubTitleLabel.bottomAnchor.constraint(equalTo: subviewsContainerView.bottomAnchor).isActive = true
    }
    
    private func backgroundImageGradient() {
        let startColor = UIColor(red: 30/255, green: 113/255, blue: 79/255, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
        
        gradientLayer.colors = [startColor, endColor]
        if gradientView.layer.sublayers == nil {
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func setTitle(mainText: String, subText: String) {
        DispatchQueue.main.async {
            self.movieTitleLabel.text = mainText
            self.moviesubTitleLabel.text = subText
        }
    }
    
    func setBackdropImage(backdropImage: UIImage?) {
        DispatchQueue.main.async {
            self.backgroundImageView.image = backdropImage
        }
    }
    
    func setPosterImage(moviePosterImage: UIImage?) {
        DispatchQueue.main.async {
            self.posterImageView.image = moviePosterImage
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        
        containerViewHeight.constant = scrollView.contentInset.top
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        if contentOffsetY <= 0 {
            subviewsContainerView.alpha = 1
        } else if contentOffsetY > 0 {
            subviewsContainerView.alpha = 1 - contentOffsetY / 100
        }
    }
    
}

class ImageViewWithGradient: UIImageView {
    let myGradientLayer: CAGradientLayer

    override init(frame: CGRect) {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        myGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let colors: [CGColor] = [
            UIColor.clear.cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
          UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor,
          UIColor.clear.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0,  0.3, 0.5, 0.7, 1.0]
        self.layer.addSublayer(myGradientLayer)
    }

    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
}
