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
