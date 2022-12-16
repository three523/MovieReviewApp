//
//  Reviews.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/22.
//

import Foundation

struct Reviews: Decodable {
    let results: [Review]
}

struct Review: Decodable {
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case author, content, url
        case authorDetails = "author_details"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AuthorDetails: Decodable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
