//
//  CreditMovie.swift
//  MovieReviewApp
//
//  Created by apple on 2022/08/25.
//

import Foundation

struct CreditMovies: Decodable {
    let cast: [CreditCastMovie]
    let crew: [CreditCrewMovie]
}

struct CreditCastMovie: Decodable {
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case overview, title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct CreditCrewMovie: Decodable {
    let originalTitle: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case overview, title, job
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

/*
 {
       "id": 76203,
       "department": "Production",
       "original_language": "en",
       "original_title": "12 Years a Slave",
       "job": "Producer",
       "overview": "In the pre-Civil War United States, Solomon Northup, a free black man from upstate New York, is abducted and sold into slavery. Facing cruelty as well as unexpected kindnesses Solomon struggles not only to stay alive, but to retain his dignity. In the twelfth year of his unforgettable odyssey, Solomon’s chance meeting with a Canadian abolitionist will forever alter his life.",
       "vote_count": 3284,
       "video": false,
       "poster_path": "/kb3X943WMIJYVg4SOAyK0pmWL5D.jpg",
       "backdrop_path": "/xnRPoFI7wzOYviw3PmoG94X2Lnc.jpg",
       "title": "12 Years a Slave",
       "popularity": 6.62674,
       "genre_ids": [
         18,
         36
       ],
       "vote_average": 7.9,
       "adult": false,
       "release_date": "2013-10-18",
       "credit_id": "52fe492cc3a368484e11dfe1"
     },
 */
/*
 "cast": [
        {
            "adult": false,
            "backdrop_path": "/c7Mjuip0jfHLY7x8ZSEriRj45cu.jpg",
            "genre_ids": [
                12,
                28
            ],
            "id": 85,
            "original_language": "en",
            "original_title": "Raiders of the Lost Ark",
            "overview": "1936년 남아메리카. 인디아나 존스 박사는 험난한 밀림 지대를 헤치고 독거미와 온갖 부비트랩을 뚫고서 고대 문명의 동굴에 보관된 보물을 손에 넣는데 성공하지만, 마지막 순간 악덕 고고학자 벨로크에게 빼앗기고 만다.  대학으로 돌아온 인디에게 정보국 사람들이 찾아온다. 정부로부터 성서에 나오는 성궤를 찾으라는 명령을 받는은 인디는 단서를 하나하나 찾아가며 성궤의 행방을 추적해 나간다. 그런데 나치군들도 역시 전쟁에 가지고 나가기만 하면 모든 전쟁에서 승리를 거둘 수 있는 무서운 힘을 지닌 성궤를 찾아나서는데...",
            "popularity": 40.999,
            "poster_path": "/xB8nOHHz8bmuM3GoW3gFttUvEks.jpg",
            "release_date": "1981-06-12",
            "title": "레이더스",
            "video": false,
            "vote_average": 7.9,
            "vote_count": 10289,
            "character": "Indiana Jones",
            "credit_id": "52fe4215c3a36847f8002a05",
            "order": 0
        },
 
 "cast": [
         {
             "adult": false,
             "backdrop_path": "/je2QsgBLEy4lzsvWprwfoZKmIX1.jpg",
             "genre_ids": [
                 12,
                 28
             ],
             "id": 89,
             "original_language": "en",
             "original_title": "Indiana Jones and the Last Crusade",
             "overview": "자신이 재직 중인 바네트 대학으로 돌아온 인디(해리슨 포드)는 몇 달만을 비워뒀던 대학 연구실에서 오래 전에 도착한 아버지의 일기장을 발견한다.  고고학에 관심 많은 학생들을 피해 겨우 창문으로 빠져나온 존슨 박사는 윌터 도노반(줄리안 글로버 분)이라는 사람을 만난다. 도노반은 자신이 앙카라 북쪽에서 발견한 반쪽짜리 신의 석판의 탁본을 보여주며 헨리 박사의 일기장을 참고로 나머지 반쪽 석판과 예수가 최후의 만찬 때 사용했다는 술잔 성배를 찾아 달라고 부탁한다. 인디아나 존스는 아버지 헨리 존스 박사가 나치에게 납치 되었다는 소식을 듣고 베니스로 달려가는데...",
             "popularity": 40.017,
             "poster_path": "/2NAbA7NFvNAlmOupYELiHK7oCcJ.jpg",
             "release_date": "1989-05-24",
             "title": "인디아나 존스: 최후의 성전",
             "video": false,
             "vote_average": 7.828,
             "vote_count": 8312,
             "character": "Indiana Jones",
             "credit_id": "52fe4216c3a36847f8002e1d",
             "order": 0,
             "media_type": "movie"
         },
 */
