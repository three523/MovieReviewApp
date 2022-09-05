//
//  SearchViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/31.
//

import Foundation

enum MediaType: String {
    case movie = "movie?"
    case tv = "tv?"
}



class SearchViewModel {
    private let shared: URLSession = URLSession.shared
    private let apiHandler: ApiHandler = ApiHandler()
    private var popularMovies: [MovieInfo]? = nil
    private var searchMovies: [MovieInfo]? = nil
    private var query: [String: String] = ["api_key": APIKEY, "language": "ko"]
    private var path: String = "search/"
    
    func getPopularMovie( completed: @escaping () -> Void ) {
        let popularPath: String = "movie/popular?"
        apiHandler.getJson(type: MovieList.self ,path: popularPath, query: query) { movieList in
            self.popularMovies = movieList.results
            completed()
        }
    }
    
    func getSearchMovie(mediaType: MediaType, search: String, completed: @escaping () -> Void ) {
        let searchPath: String = path + mediaType.rawValue
        let searchQuery = search.replacingOccurrences(of: " ", with: "+")
        query["query"] = searchQuery
        apiHandler.getJson(type: MovieList.self, path: searchPath, query: query) { movies in
            self.searchMovies = movies.results
            completed()
        }
    }
    
    func getPopularMovieList() -> [MovieInfo]? {
        return popularMovies
    }
    
    func getPopularMovieCount() -> Int {
        guard let popularMovies = popularMovies else { return 0 }
        return popularMovies.count
    }
    
    func getSearchMovieList() -> [MovieInfo]? {
        return searchMovies
    }
    
    func getSearchMovieCount() -> Int {
        guard let searchMovies = searchMovies else { return 0 }
        return searchMovies.count
    }
}