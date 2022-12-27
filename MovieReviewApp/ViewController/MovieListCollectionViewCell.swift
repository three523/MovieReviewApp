//
//  MoviewListCollectionViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/13.
//

import UIKit

class MovieListCollectionViewCell: MovieDetailCollectionViewCell {
    
    static let identifier: String = "\(MovieListCollectionViewCell.self)"
    
    let moviePoster: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.backgroundColor = .systemGray4
        return imgView
    }()
    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    let movieScoreLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 15)
        label.textColor = UIColor(red: 255/255, green: 51/255, blue: 153/255, alpha: 1)
        label.text = "평점 : 0.00"
        return label
    }()
    
    var movie: MovieInfo? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(moviePoster)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(movieScoreLable)
        
        moviePoster.clipsToBounds = true
        moviePoster.layer.cornerRadius = 10
        
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        moviePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        moviePoster.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.topAnchor.constraint(equalTo: moviePoster.bottomAnchor).isActive = true
        movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieTitleLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        
        movieScoreLable.translatesAutoresizingMaskIntoConstraints = false
        movieScoreLable.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor).isActive = true
        movieScoreLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieScoreLable.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1).isActive = true
        
    }
    
    func settingData() {
        guard let movie = movie else {
            return
        }
        guard let posterPath = movie.posterPath else { return }
        ImageLoader().tmdbImageLoad(stringUrl: posterPath, size: .poster) { image in
            DispatchQueue.main.async {
                self.moviePoster.image = image
            }
        }
        
        movieTitleLabel.text = movie.title
        movieScoreLable.text = "평점: \(movie.voteAverage)"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
