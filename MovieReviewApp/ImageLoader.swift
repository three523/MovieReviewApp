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
    private let cacheImages = NSCache<NSURL, UIImage>()
    
    private func getImage(path: String, completed: @escaping (UIImage) -> Void) {
        guard let url: URL = URL(string: "\(baseUrlString)\(path)") else { return }
        shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                let image = UIImage(data: data) else {
                print("image is nil")
                return }
            completed(image)
        }.resume()
    }
    
    private func getCaccheImage(url: NSURL) -> UIImage? {
        return cacheImages.object(forKey: url)
    }
    
    func imageLoad(stringUrl: String, completed: @escaping (UIImage) -> Void) {
        
        guard let url = NSURL(string: "\(baseUrlString)\(stringUrl)") else {
            print("url is nil")
            return
        }
        
        if let cacheImage = getCaccheImage(url: url) {
            completed(cacheImage)
            return
        }
        
        getImage(path: stringUrl) { image in
            self.cacheImages.setObject(image, forKey: url)
            completed(image)
        }
    }
}
