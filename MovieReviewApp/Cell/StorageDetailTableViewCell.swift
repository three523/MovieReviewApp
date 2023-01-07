//
//  StorageTableViewCell.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/27.
//

import UIKit

class StorageDetailTableViewCell: MovieDetailTableViewCell {
    
    static let identifier: String = "\(StorageDetailTableViewCell.self)"
    private let posterImageView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.backgroundColor = .systemGray4
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    private let titleLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.text = "                  "
        lb.textColor = .black
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let averageLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.text = "      "
        lb.textColor = .systemGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let myRatingLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.text = ""
        lb.textColor = .yellow
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private let infoLabel: UILabel = {
        let lb: UILabel = UILabel()
        lb.font = .systemFont(ofSize: 12, weight: .regular)
        lb.text = "                        "
        lb.textColor = .systemGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    var movieInfo: SummaryMediaInfo? = nil {
        didSet {
            setData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewAdd()
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(myRatingLabel)
        contentView.addSubview(averageLabel)
        contentView.addSubview(infoLabel)
    }
    
    private func setAutolayout() {
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        let posterImageAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 80)
        posterImageAnchor.priority = UILayoutPriority(999)
        posterImageAnchor.isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        
        myRatingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        myRatingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
        
        averageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        averageLabel.leadingAnchor.constraint(equalTo: myRatingLabel.trailingAnchor, constant: 10).isActive = true
        
        infoLabel.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 10).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10).isActive = true
    }
    
    private func setData() {
        guard let movieInfo = movieInfo else { return }
        titleLabel.text = movieInfo.title
        averageLabel.text = "평균★\(movieInfo.voteAverage)"
        if let posterPath = movieInfo.posterPath {
            ImageLoader.loader.tmdbImageLoad(stringUrl: posterPath, size: .poster) { image in
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
        }
        if let releaseDate = movieInfo.releaseDate,
           let countrie = movieInfo.productionCountrie,
           let genres = movieInfo.genres {
            infoLabel.text = "\(releaseDate) ∙ \(genres) ∙ \(countrie)"
        }
    }
        
}
