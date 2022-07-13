//
//  MoviewListCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/13.
//

import UIKit

class MoviewListCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "\(MoviewListCollectionViewCell.self)"
    
    let moviePoster: UIImageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up")!)
    let movieLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.numberOfLines = 2
        label.text = "영화 제목입니다."
        return label
    }()
    let scoreLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.textColor = UIColor(red: 255/255, green: 51/255, blue: 153/255, alpha: 1)
        label.text = "평점 : 9.24"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieLabel)
        contentView.addSubview(scoreLable)
        
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        moviePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        moviePoster.bottomAnchor.constraint(equalTo: movieLabel.topAnchor).isActive = true
        moviePoster.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        
        movieLabel.translatesAutoresizingMaskIntoConstraints = false
        movieLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor).isActive = true
        movieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        
        scoreLable.translatesAutoresizingMaskIntoConstraints = false
        scoreLable.topAnchor.constraint(equalTo: movieLabel.bottomAnchor).isActive = true
        scoreLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scoreLable.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
