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
    static var movieDetail: MovieDetail? = nil
    static var credits: Credits? = nil
    static var movieReleaseDate: MovieReleaseDate? = nil
    static var reviews: Reviews? = nil
    private let imageLoader: ImageLoader = ImageLoader()
    private var query: [String: String] = ["api_key": APIKEY, "language": "ko"]
    private var path: String = "movie/"
    
    init(movieId: String) {
        self.movieId = movieId
    }
    
    func getMovieDetail(completed: @escaping () -> Void) {
        let detailPath: String = path + movieId + "?"
        var detailQuery: [String: String] = query
        detailQuery["append_to_response"] = "release_dates"
        apiHandler.getJson(type: MovieDetail.self, path: detailPath, query: detailQuery) { movieDetail in
            MovieDetailViewModel.movieDetail = movieDetail
            completed()
        }
    }
    
    func getCredits(completed: @escaping () -> Void) {
        let creditsPath: String = path + movieId + "/credits?"
        apiHandler.getJson(type: Credits.self, path: creditsPath, query: query) { credits in
            MovieDetailViewModel.credits = credits
            completed()
        }
    }
    
    func getReleaseDate(completed: @escaping() -> Void) {
        let releasePath: String = path + movieId + "/release_dates?"
        apiHandler.getJson(type: MovieReleaseDate.self, path: releasePath, query: query) { movieReleaseDate in
            MovieDetailViewModel.movieReleaseDate = movieReleaseDate
            completed()
        }
    }
    
    func getReviews(completed: @escaping() -> Void) {
        let reviewsPath: String = path + movieId + "/reviews?"
        apiHandler.getJson(type: Reviews.self, path: reviewsPath, query: query) { reviews in
            if reviews.results.isEmpty {
                let enQurey: [String: String] = ["api_key": APIKEY, "language": "en-US"]
                self.apiHandler.getJson(type: Reviews.self, path: reviewsPath, query: enQurey) { reviews in
                    MovieDetailViewModel.reviews = reviews
                    print("en")
                    completed()
                }
            } else {
                MovieDetailViewModel.reviews = reviews
                print("ko")
                completed()
            }
        }
    }
    
    func getMovie() -> MovieDetail? {
        return MovieDetailViewModel.movieDetail
    }
    
    func getBackdropImage(completed: @escaping (UIImage) -> Void) {
        guard let movieDetail = MovieDetailViewModel.movieDetail,
              let backdropImageUrl = movieDetail.backdropPath else {
            print("movieDetail or backdropPath is nil")
            return
        }
        imageLoader.imageLoad(stringUrl: backdropImageUrl, size: .bacdrop) { backdropImage in
            completed(backdropImage)
        }
    }
    
    func getPosterImage(completed: @escaping (UIImage) -> Void) {
        guard let movieDetail = MovieDetailViewModel.movieDetail,
        let posterImageUrl = movieDetail.posterPath else {
            print("movieDetail or posterPath is nil")
            return
        }
        imageLoader.imageLoad(stringUrl: posterImageUrl, size: .poster) { posterImage in
            completed(posterImage)
        }
    }
    
}
