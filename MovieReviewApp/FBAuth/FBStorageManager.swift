//
//  FBStorageManager.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/15.
//

import FirebaseStorage
import Firebase

final class FBStorageManager {
    static func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString
        print(imageName)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                }
                completion(url)
            }
        }
    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    static func deleteImage(urlString: String, completed: @escaping () -> Void) {
        let storageRefernce = Storage.storage().reference(forURL: urlString)
        storageRefernce.delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
            completed()
        }
    }
}
