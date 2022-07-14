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
    let results: [MovieDetail]
}

struct MovieDetail: Decodable {
    let id: Int
    let backdropPath: String?
    let title: String
    let originalTitle: String?
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity
        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
/*
 {
             "adult": false,
             "backdrop_path": "/nmGWzTLMXy9x7mKd8NKPLmHtWGa.jpg",
             "genre_ids": [
                 10751,
                 16,
                 12,
                 35,
                 14
             ],
             "id": 438148,
             "original_language": "en",
             "original_title": "Minions: The Rise of Gru",
             "overview": "세계 최고의 슈퍼 악당을 꿈꾸는 미니보스 ‘그루’와 그를 따라다니는 미니언들.\r 어느 날 그루는 최고의 악당 조직 ‘빌런6’의 마법 스톤을 훔치는 데 성공하지만\r 뉴페이스 미니언 ‘오토’의 실수로 스톤을 잃어버리고 빌런6에게 납치까지 당한다.\r 미니보스를 구하기 위해 잃어버린 스톤을 되찾아야 하는 ‘오토’, 그리고 쿵푸를 마스터해야 하는 ‘케빈’, ‘스튜어트’, ‘밥’!\r 올여름 극장가를 점령할 MCU(미니언즈 시네마틱 유니버스)가 돌아온다!",
             "popularity": 15259.056,
             "poster_path": "/1heBUD8o0sgdqLWyeXkylR2POKb.jpg",
             "release_date": "2022-06-29",
             "title": "미니언즈 2",
             "video": false,
             "vote_average": 7.8,
             "vote_count": 270
         },
 */
