//
//  PersonMoviesCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/25.
//

import UIKit

class PersonMoviesTableViewCell: UITableViewCell {
    
    static let identifier: String = "\(PersonMoviesTableViewCell.self)"
    var movieId: Int = 0
    let posterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    let movieTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    let movieDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray2
        return label
    }()
    lazy var textAreaStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [movieTitleLabel, movieDescriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(textAreaStackView)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.7).isActive = true
        
        textAreaStackView.translatesAutoresizingMaskIntoConstraints = false
        textAreaStackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor).isActive = true
        textAreaStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        textAreaStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
