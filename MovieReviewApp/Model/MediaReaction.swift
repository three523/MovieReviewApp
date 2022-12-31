//
//  MediaStorage.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/28.
//

import Foundation

typealias MovieId = String

struct MyReaction: Codable {
    var rated: [SummaryMediaInfo]?
    var wanted: [SummaryMediaInfo]?
    var watching: [SummaryMediaInfo]?
    var asDictionary: [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
    
    static var empty: MyReaction = MyReaction(rated: [], wanted: [], watching: [])
    
    enum CodingKeys: String, CodingKey {
        case rated = "Rated"
        case wanted = "Wanted"
        case watching = "Watching"
    }
}

struct SummaryMediaInfo: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genres: String?
    let productionCountrie: String?
    
    var asDictionary: [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "title" : title,
            "poster_path" : posterPath,
            "release_date" : releaseDate,
            "vote_average" : voteAverage,
            "genres" : genres,
            "production_countries" : productionCountrie
        ]
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, genres
        case posterPath = "poster_path"
        case productionCountrie = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
