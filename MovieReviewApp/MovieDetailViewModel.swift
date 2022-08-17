//
//  MovieDetailViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/02.
//

import UIKit

class MovieDetailViewModel {
    private let urlSession: URLSession = URLSession.shared
    private let apiHandler: ApiHandler = ApiHandler()
    private let movieId: String
    private var movieDetail: MovieDetail? = nil
    private let imageLoader: ImageLoader = ImageLoader()
    
    init(movieId: String) {
        self.movieId = movieId
    }
    
    func getMovieDetail(completed: @escaping () -> Void) {
        let query: [String: String] = ["api_key": APIKEY, "language": "ko"]
        let path: String = "movie/\(movieId)?"
        apiHandler.getJson(type: MovieDetail.self, path: path, query: query) { movieDetail in
            self.movieDetail = movieDetail
            completed()
        }
    }
    
    func getMovie() -> MovieDetail? {
        return movieDetail
    }
    
    func getBackdropImage(completed: @escaping (UIImage) -> Void) {
        guard let movieDetail = movieDetail,
              let backdropImageUrl = movieDetail.backdropPath else {
            print("movieDetail or backdropPath is nil")
            return
        }
        imageLoader.imageLoad(stringUrl: backdropImageUrl, size: .bacdrop) { backdropImage in
            completed(backdropImage)
        }
    }
    
    func getPosterImage(completed: @escaping (UIImage) -> Void) {
        guard let movieDetail = movieDetail,
        let posterImageUrl = movieDetail.posterPath else {
            print("movieDetail or posterPath is nil")
            return
        }
        imageLoader.imageLoad(stringUrl: posterImageUrl, size: .poster) { posterImage in
            completed(posterImage)
        }
    }
    
}
