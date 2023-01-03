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
    private var popularMovies: [SummaryMediaInfo]? = nil
    private var searchMovies: [SummaryMediaInfo]? = nil
    private var searchPersons: [SearchPersonResult]? = nil
    private var searchTVs: [TVSearchResult]? = nil
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
        if mediaType == .movie {
            apiHandler.getJson(type: MovieList.self, path: searchPath, query: query) { movies in
                self.searchMovies = movies.results
                completed()
            }
        } else {
            apiHandler.getJson(type: TV.self, path: searchPath, query: query) { tvList in
                self.searchTVs = tvList.results
                completed()
            }
        }
    }
    
    func getSearchPerson(search: String, completed: @escaping () -> Void ) {
        let searchPath: String = path + "person?"
        query["query"] = search
        apiHandler.getJson(type: SearchPerson.self, path: searchPath, query: query) { personList in
            self.searchPersons = personList.results
            completed()
        }
    }
    
    func getPopularMovieList() -> [SummaryMediaInfo]? {
        return popularMovies
    }
    
    func getPopularMovieCount() -> Int {
        guard let popularMovies = popularMovies else { return 0 }
        return popularMovies.count
    }
    
    func getSearchMovieList() -> [SummaryMediaInfo]? {
        return searchMovies
    }
    
    func getSearchMovieCount() -> Int {
        guard let searchMovies = searchMovies else { return 0 }
        return searchMovies.count
    }
    
    func getSearchTVList() -> [TVSearchResult]? {
        return searchTVs
    }
    
    func getSearchTVCount() -> Int {
        guard let searchTVs = searchTVs else { return 0 }
        return searchTVs.count
    }
    
    func getSearchPersonList() -> [SearchPersonResult]? {
        guard let searchPersons = searchPersons else {
            print("searh person nil")
            return nil
        }
        return searchPersons
    }
    
    func getSearchPersonCount() -> Int {
        guard let searchPersons = searchPersons else {
            return 0
        }
        return searchPersons.count
    }
}
