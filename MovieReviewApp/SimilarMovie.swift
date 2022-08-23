//
//  Similar.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/23.
//

import Foundation

struct SimilarMovies: Decodable {
    let results: [SimilarMovie]
}

struct SimilarMovie: Decodable {
    let posterPath: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
    }
}
