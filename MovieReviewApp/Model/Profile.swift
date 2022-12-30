//
//  Profile.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/28.
//

import Foundation

struct Profile {
    var nickname: String
    var introduction: String
    var profileImage: String
    
    init(nickname: String, introduction: String = "", profileImage: String) {
        self.nickname = nickname
        self.introduction = introduction
        self.profileImage = profileImage
    }
}
