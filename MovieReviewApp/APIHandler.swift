//
//  APIHandler.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/13.
//

import Foundation

class ApiHandler {
    private let baseUrl: String = "https://api.themoviedb.org/3/"
    private let shared: URLSession = URLSession.shared
    
    func getJson(path: String, query: [String: String], completed: @escaping (MovieList) -> Void) {
        
        let fullPath: String = self.baseUrl + path + query.map{ k, v in "\(k)=\(v)" }.joined(separator: "&")
        print("path: \(path), query: \(query)")
        print("fullPath: \(fullPath)")
        guard let url = URL(string: fullPath) else {
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
