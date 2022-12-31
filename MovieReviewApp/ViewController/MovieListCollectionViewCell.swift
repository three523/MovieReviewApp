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
    
    //MARK: movieInfo 없이 작동시 지울예정
    var movie: MovieInfo? = nil {
        willSet {
            self.settingData()
        }
    }
    var movieTest: SummaryMediaInfo? = nil {
        didSet {
            settingData()
        }
    }
    
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
        if let movie = movieTest {
            if let posterPath = movie.posterPath {
                ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { image in
                    DispatchQueue.main.async {
                        self.moviePoster.image = image
                    }
                }
            }
            
            movieTitleLabel.text = movie.title
            guard let average = movie.voteAverage else {
                movieScoreLable.text = "평점: 0"
                return
            }
            movieScoreLable.text = "평점: \(average)"
        }
        //TODO: MovieInfo => SummaryMediaInfo 로 전부 전환후에 지우기
        guard let movie = movie else {
            return
        }
        if let posterPath = movie.posterPath {
            ImageLoader().tmdbImageLoad(stringUrl: posterPath, size: .poster) { image in
                DispatchQueue.main.async {
                    self.moviePoster.image = image
                }
            }
        }
        
        movieTitleLabel.text = movie.title
        movieScoreLable.text = "평점: \(movie.voteAverage)"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
