//
//  MovieCodable.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/13.
//

import Foundation

struct HomeVCMovie {
    var popularMovie: MovieList
    var topRatedMovie: MovieList
    var upComingMovie: MovieList
}

struct MovieList: Decodable {
    let results: [SummaryMediaInfo]
}

struct SummaryMediaInfo: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let genres: String?
    let productionCountrie: String?
    var myRate: Double?
    
    var asDictionary: [String : Any] {
        let dict: [String : Any] = [
            "id" : id,
            "title" : title,
            "poster_path" : posterPath,
            "release_date" : releaseDate,
            "vote_average" : voteAverage,
            "genres" : genres,
            "production_countries" : productionCountrie,
            "myRate": myRate
        ]
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, genres, myRate
        case posterPath = "poster_path"
        case productionCountrie = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}


struct MovieDetail: Decodable {
    let id: Int
    let backdropPath: String?
    let genres: [Genres]
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let productionCountries: [ProductionCountries]
    let releaseDate: String
    let runtime: Int?
    let tagline: String?
    let title: String
    let voteAverage: Double
    let voteCount: Int
    let releaseDates: MovieReleaseDate
    
    enum CodingKeys: String, CodingKey {
        case id, genres, overview, runtime, tagline, title
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDates = "release_dates"
    }
}

struct Genres: Decodable {
    let name: String
}

struct ProductionCountries: Decodable {
    let name: String
}
