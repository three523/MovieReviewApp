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
    
    func getJson<T: Decodable>(type: T.Type, path: String, query: [String: String], completed: @escaping (T) -> Void) {
        
        let fullPath: String = self.baseUrl + path + query.map{ k, v in "\(k)=\(v)" }.joined(separator: "&")
        print("path: \(path), query: \(query)")
        print("fullPath: \(fullPath)")
        guard let encoded = fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
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
                let json: T = try jsonEncoder.decode(T.self, from: data)
                completed(json)
            } catch let e {
                print(fullPath)
                print(T.self)
                print(e.localizedDescription)
            }

        }.resume()
    }
}
