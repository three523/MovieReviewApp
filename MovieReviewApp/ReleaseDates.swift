//
//  Certification.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/19.
//

import Foundation

struct MovieReleaseDate: Decodable {
    let results: [ReleaseResults]
}

struct ReleaseResults: Decodable {
    let iso31661: String
    let releaseDates: [ReleaseDates]
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case releaseDates = "release_dates"
    }
}

struct ReleaseDates: Decodable {
    let certification: String
    let iso6391: String
    
    enum CodingKeys: String, CodingKey {
        case certification
        case iso6391 = "iso_639_1"
    }
}
