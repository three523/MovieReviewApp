//
//  HomeViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/14.
//

import Foundation

class HomeViewModel {
    private let apiHandler: ApiHandler = ApiHandler()
    private let kinds: [String] = ["popular", "top_rated", "upcoming"]
    private var movies: HomeVCMovie = HomeVCMovie(popularMovie: MovieList(results: []), topRatedMovie: MovieList(results: []), upComingMovie: MovieList(results: []))
    
    func getMovies(completed: @escaping (HomeVCMovie) -> Void) {
        
        for index in 0..<kinds.count {
            apiHandler.getJson(kind: kinds[index], language: "ko") { movieList in
                if index == 0 { self.movies.popularMovie = movieList }
                else if index == 1 { self.movies.topRatedMovie = movieList }
                else { self.movies.upComingMovie = movieList }
                
                if !(self.moviesIsEmpty()) {
                    completed(self.movies)
                }
            }
        }
    }
    
    func getPopualrMovieList() -> [MovieDetail] {
        return movies.popularMovie.results
    }
    
    func getPopularMovie(at index: Int) -> MovieDetail? {
        let movies = movies.popularMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func getTopratedMovieList() -> [MovieDetail] {
        return movies.topRatedMovie.results
    }
    
    func getTopratedMovie(at index: Int) -> MovieDetail? {
        let movies = movies.topRatedMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func getUpcomingMovieList() -> [MovieDetail] {
        return movies.upComingMovie.results
    }
    
    func getUpComingMovie(at index: Int) -> MovieDetail? {
        let movies = movies.upComingMovie.results
        guard 0 <= index && index < movies.count else { return nil }
        return movies[index]
    }
    
    func moviesIsEmpty() -> Bool {
        return movies.popularMovie.results.isEmpty || movies.topRatedMovie.results.isEmpty || movies.upComingMovie.results.isEmpty
    }
}
