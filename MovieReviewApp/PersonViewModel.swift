//
//  PersonViewModel.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/25.
//

import Foundation

class PersonViewModel {
    let shared: URLSession = URLSession.shared
    var creditMovies: CreditMovies? = nil
    let apiHandler: ApiHandler = ApiHandler()
    private var query: [String: String] = ["api_key": APIKEY, "language": "ko"]
    private var path: String = "person/"
    
    func getPersonMovie(personId: String, completed: @escaping () -> Void ) {
        let personPath: String = path + personId + "/movie_credits?"
        apiHandler.getJson(type: CreditMovies.self, path: personPath, query: query) { movies in
            self.creditMovies = movies
            completed()
        }
    }
    
}
