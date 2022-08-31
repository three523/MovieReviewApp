//
//  MovieReviewApp
//
//  Created by apple on 2022/08/03.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    weak var currentVC: UIViewController? = nil
    var movieId: Int? = nil
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentMovieDetail() {
        guard let currentVC = currentVC,
            let movieId = movieId else {
            print("currentVC or movieId is nil")
            return
        }
        let movieDetailVC: MovieDetailViewController = MovieDetailViewController()
        movieDetailVC.modalPresentationStyle = .fullScreen
        movieDetailVC.movieId = "\(movieId)"
        currentVC.present(movieDetailVC, animated: true)
    }
}

class MovieDetailCollectionViewCell: UICollectionViewCell {
    weak var currentVC: UIViewController? = nil
    var movieId: Int? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentMovieDetail() {
        guard let currentVC = currentVC,
            let movieId = movieId else {
            print("currentVC is nil")
            return
        }
        let movieDetailVC: MovieDetailViewController = MovieDetailViewController()
        movieDetailVC.modalPresentationStyle = .fullScreen
        movieDetailVC.movieId = "\(movieId)"
        currentVC.present(movieDetailVC, animated: true)
    }
}
