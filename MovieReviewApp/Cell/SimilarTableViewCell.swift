//
//  SimilarTableViewCell.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/23.
//

import UIKit

class SimilarTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier: String = "\(SimilarTableViewCell.self)"
    let similarLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        return layout
    }()
    lazy var similarCollectionView: UICollectionView = {
        let itemSize: CGFloat = (contentView.frame.size.width / 3).rounded(.down)
        similarLayout.itemSize = CGSize(width: itemSize, height: itemSize * 2)
        let cv: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: similarLayout)
        return cv
    }()
    weak var navigationController: UINavigationController? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.isScrollEnabled = false
                
        similarCollectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        
        contentView.addSubview(similarCollectionView)
        
        similarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        similarCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        similarCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        similarCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        similarCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("SimilarMovie: \(MovieDetailViewModel.similarMovies?.results)")
        guard let similarMoviesCount = MovieDetailViewModel.similarMovies?.results.count else { return 0 }
        return similarMoviesCount > 9 ? 9 : similarMoviesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else { return UICollectionViewCell() }
                
        guard let similarMovies = MovieDetailViewModel.similarMovies?.results else { return cell }
                
        if indexPath.row <= similarMovies.count {
            let similarMovie: SimilarMovie = similarMovies[indexPath.row]
            cell.movieId = similarMovie.id
            cell.movieTitleLabel.text = similarMovie.title
            cell.movieScoreLable.text = "\(similarMovie.voteAverage)"
            
            ImageLoader.loader.tmdbImageLoad(stringUrl: similarMovie.posterPath, size: .poster) { posterImage in
                DispatchQueue.main.async {
                    cell.moviePoster.image = posterImage
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieListCollectionViewCell,
        let navigationController = navigationController else { return }
        cell.navigationController = navigationController
        cell.presentMovieDetail()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        similarCollectionView.layoutIfNeeded()
        similarCollectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width - 20 , height: targetSize.height)
        
        return similarLayout.collectionViewContentSize
    }

}
