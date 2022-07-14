//
//  APIHandler.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/13.
//

import Foundation

class ApiHandler {
    private let baseUrl: String = "https://api.themoviedb.org/3/movie/"
    private let shared: URLSession = URLSession.shared
    
    func getJson(kind: String, language: String, completed: @escaping (MovieList) -> Void) {
        guard let url: URL = URL(string: "\(baseUrl)\(kind)?api_key=\(APIKEY)&language=\(language)") else {
            print("url is nil")
            return
        }
        
        shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("data is nil")
                return
            }
            
            let jsonEncoder: JSONDecoder = JSONDecoder()
                        
            do {
                let movie: MovieList = try jsonEncoder.decode(MovieList.self, from: data)
                completed(movie)
            } catch let e {
                print(e.localizedDescription)
            }
            

        }.resume()
    }
}
