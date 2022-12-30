//
//  ImageLoader.swift
//  MovieReviewApp
//
//  Created by apple on 2022/07/14.
//

import Foundation
import UIKit

enum ImageSize: String {
    case poster = "/w185"
    case bacdrop = "/w780"
}

class ImageLoader {
    
    private let shared: URLSession = URLSession.shared
    private let baseUrlString: String = "https://image.tmdb.org/t/p"
    private let cacheImages = NSCache<NSURL, UIImage>()
    public static let loader: ImageLoader = ImageLoader()
    
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
    
    private func getDefaultImage(path: String, completed: @escaping (UIImage) -> Void) {
        print(baseUrlString, path)
        guard let url: URL = URL(string: "\(path)") else { return }
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
    
    func profileImage(stringURL: String, size: ImageSize, compelted: @escaping (UIImage) -> Void) {
        let checkImagePath: Substring = stringURL.prefix(6)
        if checkImagePath == "/https" {
            let strurl = String(stringURL.dropFirst())
            defaultImageLoad(stringUrl: strurl) { image in
                compelted(image)
            }
        } else {
            tmdbImageLoad(stringUrl: stringURL, size: .poster) { image in
                compelted(image)
            }
        }
    }
    
    func tmdbImageLoad(stringUrl: String, size: ImageSize ,completed: @escaping (UIImage) -> Void) {
        guard let url = NSURL(string: "\(baseUrlString)\(size.rawValue)\(stringUrl)") else {
            print("url is nil")
            return
        }
        if let cacheImage = getCaccheImage(url: url) {
            completed(cacheImage)
            return
        }
        
        let path: String = "\(size.rawValue)\(stringUrl)"
        getImage(path: path) { image in
            self.cacheImages.setObject(image, forKey: url)
            completed(image)
        }
    }
    
    func defaultImageLoad(stringUrl: String ,completed: @escaping (UIImage) -> Void) {
        guard let url = NSURL(string: "\(stringUrl)") else {
            print("url is nil")
            return
        }
        if let cacheImage = getCaccheImage(url: url) {
            completed(cacheImage)
            return
        }
        
        let path: String = "\(stringUrl)"
        getDefaultImage(path: path) { image in
            self.cacheImages.setObject(image, forKey: url)
            completed(image)
        }
    }
}
