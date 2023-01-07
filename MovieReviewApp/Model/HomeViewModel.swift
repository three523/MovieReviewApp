//
//  HomeViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/14.
//

import Foundation

class HomeViewModel {
    private let apiHandler: ApiHandler = ApiHandler()
    private let kinds: [String] = ["movie/popular?", "movie/top_rated?", "movie/upcoming?"]
    private var movies: HomeVCMovie = HomeVCMovie(popularMovie: MovieList(results: []), topRatedMovie: MovieList(results: []), upComingMovie: MovieList(results: []))
    private var reactionMediaModel: MyReactionModel = MyReactionModel()
    var viewUpdate: ()->() = {}
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateReactionList), name: Notification.Name("UpdateReactionList"), object: nil)
    }
    
    func getMovies() {
        reactionMediaModel.fetchRatedMediaInfos { summaryMediaInfos in
            for index in 0..<self.kinds.count {
                self.apiHandler.getJson(type: MovieList.self ,path: self.kinds[index], query: ["api_key": APIKEY, "language": "ko"]) { movieList in
                    var filterMovies = movieList
                    for (index, movie) in movieList.results.enumerated() {
                        if let ratedMovie = summaryMediaInfos.first(where: { $0.id == movie.id }) {
                            filterMovies.results[index] = ratedMovie
                        }
                    }
                    if index == 0 { self.movies.popularMovie = filterMovies }
                    else if index == 1 { self.movies.topRatedMovie = filterMovies }
                    else { self.movies.upComingMovie = filterMovies }
                    self.viewUpdate()
                }
            }
        }
    }
    
    func getPopualrMovieList() -> [SummaryMediaInfo] {
        return movies.popularMovie.results
    }
    
    func getPopularMovie(at index: Int) -> SummaryMediaInfo? {
        let movies = movies.popularMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func getTopratedMovieList() -> [SummaryMediaInfo] {
        return movies.topRatedMovie.results
    }
    
    func getTopratedMovie(at index: Int) -> SummaryMediaInfo? {
        let movies = movies.topRatedMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func getUpcomingMovieList() -> [SummaryMediaInfo] {
        return movies.upComingMovie.results
    }
    
    func getUpComingMovie(at index: Int) -> SummaryMediaInfo? {
        let movies = movies.upComingMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func moviesIsEmpty() -> Bool {
        return movies.popularMovie.results.isEmpty || movies.topRatedMovie.results.isEmpty || movies.upComingMovie.results.isEmpty
    }
    
    @objc
    func updateReactionList() {
        getMovies()
    }
}
