//
//  ImageLoader.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/14.
//

import Foundation
import UIKit

class ImageLoader {
    private let shared: URLSession = URLSession.shared
    private let baseUrlString: String = "https://image.tmdb.org/t/p/w200"
    func getImage(path: String, completed: @escaping (UIImage)->()) {
        guard let url: URL = URL(string: "\(baseUrlString)\(path)") else { return }
        shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                let image = UIImage(data: data) else {
                print("image is nil")
                return }
            completed(image)
        }.resume()
    }
}
