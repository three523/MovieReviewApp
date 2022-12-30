//
//  StorageViewModel.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/28.
//

import Foundation
import FirebaseDatabase

/*
 moviestorage {
    평가한 : String = movieId: String
    보고싶어요 : String = movieId: String
    보는중 : String = movieId: String
 }
 dramatorage: String = [
    평가한 : String = movieId: String
    보고싶어요 : String = movieId: String
    보는중 : String = movieId: String
 ]
 [String: [String: String]]
 */

enum MediaReaction: String {
    case rated = "Rated"
    case wanted = "Wanted"
    case watching = "Watching"
}

class StorageViewModel {
    private var myStorage: MyReaction?
    private let fbDatabaseManager: FBDataBaseManager = FBDataBaseManager()
    
    func getMediaStorageStorage(completed: @escaping (MyReaction) -> ()) {
        if let myStorage = myStorage {
            return completed(myStorage)
        }
        firebaseStorage { myStorage in
            self.myStorage = myStorage
            completed(myStorage)
        }
    }
    
    private func firebaseStorage(completed: @escaping (MyReaction) -> ()) {
        fbDatabaseManager.getDataSnapshot(type: .storage) { result in
            switch  result {
            case .success(let snapshot):
                let myReaction = self.dataSnapshotToReactionList(dataSnapshot: snapshot)
                completed(myReaction)
            case .failure(let failure):
                print(failure.localizedDescription)
                completed(MyReaction.empty)
            }
        }
    }
    
    private func dataSnapshotToReactionList(dataSnapshot: DataSnapshot) -> MyReaction {
        guard let dataSnapshot = dataSnapshot.value as? [String : Any] else {
            print("ReactionList is nil")
            return MyReaction.empty
        }
        let myRecation = dictionaryToObject(objectType: MyReaction.self, dictionary: dataSnapshot)
        return myRecation ?? MyReaction.empty
    }
    
    func dictionaryToObject<T:Decodable>(objectType: T.Type, dictionary: [String : Any]) -> T? {
        
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let object = try decoder.decode(objectType, from: dictionaries)
            return object
        } catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
}
