//
//  File.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/19.
//

import Foundation

struct Credits: Decodable {
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let name: String
    let profilePath: String?
    let character: String
    let creditId: String
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, character
        case profilePath = "profile_path"
        case creditId = "credit_id"
    }
}

struct Crew: Decodable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let name: String
    let profilePath: String?
    let creditId: String
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, job
        case profilePath = "profile_path"
        case creditId = "credit_id"
    }
}


/*
 "cast": [
         {
             "adult": false,
             "gender": 2,
             "id": 74568,
             "known_for_department": "Acting",
             "name": "Chris Hemsworth",
             "original_name": "Chris Hemsworth",
             "popularity": 116.409,
             "profile_path": "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg",
             "cast_id": 85,
             "character": "Thor Odinson",
             "credit_id": "62c8c25290b87e00f53973fb",
             "order": 0
         },
 
 "crew": [
        {
            "adult": false,
            "gender": 1,
            "id": 7232,
            "known_for_department": "Production",
            "name": "Sarah Halley Finn",
            "original_name": "Sarah Halley Finn",
            "popularity": 11.541,
            "profile_path": "/pI3OhmnHhXLEwuv0Vq6qJHivCJA.jpg",
            "credit_id": "6030db0fb4a543004111cbf0",
            "department": "Production",
            "job": "Casting"
        },
 {
             "adult": false,
             "gender": 2,
             "id": 55934,
             "known_for_department": "Directing",
             "name": "Taika Waititi",
             "original_name": "Taika Waititi",
             "popularity": 49.545,
             "profile_path": "/tQeioTj98JxIXldV9yDSUXNt3KY.jpg",
             "credit_id": "5d2e0eb4caab6d164099c274",
             "department": "Directing",
             "job": "Director"
         },
 
 */
