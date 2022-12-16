//
//  SearchPerson.swift
//  MovieReviewApp
//
//  Created by apple on 2022/09/06.
//

import Foundation

struct SearchPerson: Decodable {
    let results: [SearchPersonResult]
}

struct SearchPersonResult: Decodable {
    let id: Int
    let department: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case department = "known_for_department"
        case profilePath = "profile_path"
    }
}
