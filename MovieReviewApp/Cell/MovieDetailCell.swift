//
//  MovieReviewApp
//
//  Created by apple on 2022/08/03.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    weak var navigationController: UINavigationController? = nil
    var movieId: Int? = nil
    var rated: Double?
    let myReactionModel: MyReactionModel = MyReactionModel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        myReactionModel.requestDataSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentMovieDetail() {
        guard let navigationController = navigationController,
            let movieId = movieId else {
            print("currentVC or movieId is nil")
            return
        }
        let movieDetailVC: MovieDetailViewController = MovieDetailViewController()
        movieDetailVC.modalPresentationStyle = .fullScreen
        movieDetailVC.movieId = "\(movieId)"
        if let rateMediaInfo = myReactionModel.myReactionList.rated?.first(where: { $0.id == movieId }) {
            movieDetailVC.rated = rateMediaInfo.myRate
            print("MovieRated: \(rateMediaInfo)")
        }
        navigationController.pushViewController(movieDetailVC, animated: true)
    }
}

class MovieDetailCollectionViewCell: UICollectionViewCell {
    weak var navigationController: UINavigationController? = nil
    var movieId: Int? = nil
    var rated: Double?
    let myReactionModel: MyReactionModel = MyReactionModel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        myReactionModel.requestDataSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentMovieDetail() {
        guard let navigationController = navigationController,
            let movieId = movieId else {
            print("currentVC is nil")
            return
        }
        let movieDetailVC: MovieDetailViewController = MovieDetailViewController()
        movieDetailVC.modalPresentationStyle = .fullScreen
        movieDetailVC.movieId = "\(movieId)"
        if let rateMediaInfo = myReactionModel.myReactionList.rated?.first(where: { $0.id == movieId }) {
            movieDetailVC.rated = rateMediaInfo.myRate
            print("MovieRated: \(rateMediaInfo)")
        }
        navigationController.pushViewController(movieDetailVC, animated: true)
    }
}
