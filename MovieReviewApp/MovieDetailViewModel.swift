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
    
    init(movieId: String) {
        self.movieId = movieId
    }
    
    func getMovieDetail(completed: @escaping (MovieDetail) -> Void) {
        let query: [String: String] = ["api_key": APIKEY, "language": "ko"]
        let path: String = "movie/\(movieId)?"
        apiHandler.getJson(type: MovieDetail.self, path: path, query: query) { movieDetail in
            self.movieDetail = movieDetail
            completed(movieDetail)
        }
    }
    
}
