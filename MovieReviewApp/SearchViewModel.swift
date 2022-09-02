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

enum InputType: String {
    case en = "en-US"
    case ko = "ko"
}

class SearchViewModel {
    private let shared: URLSession = URLSession.shared
    private let apiHandler: ApiHandler = ApiHandler()
    private var popularMovies: [MovieInfo]? = nil
    private var searchMovies: [MovieInfo]? = nil
    private var query: [String: String] = ["api_key": APIKEY]
    private var path: String = "search/"
    
    func getPopularMovie( completed: @escaping () -> Void ) {
        let popularPath: String = "movie/popular?"
        apiHandler.getJson(type: MovieList.self ,path: popularPath, query: ["api_key": APIKEY, "language": "ko"]) { movieList in
            self.popularMovies = movieList.results
            completed()
        }
    }
    
    func getSearchMovie(mediaType: MediaType, inputType: InputType, search: String, completed: @escaping () -> Void ) {
        let searchPath: String = path + mediaType.rawValue
        query["language"] = inputType.rawValue
        query["query"] = search
        apiHandler.getJson(type: MovieList.self, path: searchPath, query: query) { movies in
            self.searchMovies = movies.results
            completed()
        }
    }
    
    func getPopularMovieList() -> [MovieInfo]? {
        return popularMovies
    }
    
    func getSearchMovieList() -> [MovieInfo]? {
        return searchMovies
    }
}
