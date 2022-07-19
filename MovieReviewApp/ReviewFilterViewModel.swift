//
//  ReviewFilterViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/19.
//

import Foundation

class ReviewFilterViewModel {
    private let shared: URLSession = URLSession.shared
    private let apiHandler: ApiHandler = ApiHandler()
    private var movieListModel: MovieList? = nil
    
    func movieList(findData: String, path: String, section: Int, completed: @escaping (MovieList)->Void) {
        
        if section == 1 {
            var findedData: [String:String] = [:]
            for list in genres {
                if list["name"] == findData { findedData = list }
            }
            apiHandler.getJson(path: path, query: ["api_key":APIKEY, "with_genres": findedData["id"]!, "language": "ko"], completed: { movieList in
                self.movieListModel = movieList
                completed(movieList)
                print(movieList)
            })
        } else {
            var findedData: [String: String] = [:]
            for list in movieFilterList {
                if list["name"] == findData {
                    findedData = list
                }
            }
            if findData == "랜덤 영화" {
                let page = Int.random(in: 1...1000)
                apiHandler.getJson(path: path, query: ["api_key": APIKEY, "page": String(page), "language": "ko"]) { movieList in
                    print(movieList)
                    completed(movieList)
                }
            }
            apiHandler.getJson(path: path, query: ["api_key": APIKEY, "language": "ko"]) { movieList in
                print(movieList)
                self.movieListModel = movieList
                completed(movieList)
            }
        }
    }
    
    func getCount() -> Int {
        guard let count = movieListModel?.results.count else { return 0 }
        return count
    }
    
    func getMovieList() -> [MovieDetail]? {
        guard let movieList = movieListModel?.results else { return nil }
        return movieList
    }
    
    func getMovie(index: Int) -> MovieDetail? {
        guard let movieDetail = movieListModel?.results[index] else {
            print("movieDetail is nil")
            return nil
        }
        return movieDetail
    }
}
