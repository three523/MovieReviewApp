//
//  FBDB.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/14.
//

import FirebaseDatabase
import FirebaseAuth

protocol FBAuthDatabase {
    var databaseManager: FBDataBaseManager? { get set }
    var name: String { get set }
}

// 처음에 로그인시 기존 프로필 정보가 있으면 가져오고 아닌경우 새로 만들어 저장하는 기능
extension FBAuthDatabase where Self: UIViewController {
    func setDatabaseProfile() {
        guard let databaseManager = databaseManager else {
            print("DatabaseManager nil")
            return
        }
        databaseManager.getDataSnapshot(type: .profile) { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let failure):
                print(failure.localizedDescription)
                let profile = Profile(nickname: self.name, profileImage: "")
                databaseManager.setProfile(profile: profile)
            }
            self.dismiss(animated: false)
        }
    }
}

enum FireBaseDataType {
    case profile
    case storage
}

final class FBDataBaseManager {
    private let baseRef: DatabaseReference = Database.database().reference()
    
    public func getDataSnapshot(type: FireBaseDataType, completed: @escaping (Result<DataSnapshot,Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completed(.failure(FBDatabaseManagerError.emailNil))
            return
        }
        switch type {
        case .profile:
            let ref = baseRef.child("User").child(uid).child("Profile")
            ref.getData { error, snapshot in
                if let error = error {
                    completed(.failure(error))
                    return
                }
                if let snapshot = snapshot,
                   let _ = snapshot.value as? [String: String] {
                    completed(.success(snapshot))
                    return
                }
                completed(.failure(FBDatabaseManagerError.snapShotNil))
            }
        case .storage:
            let ref = baseRef.child("User").child(uid).child("Storage")
            ref.getData { error, snapshot in
                if let error = error {
                    completed(.failure(error))
                    return
                }
                if let snapshot = snapshot,
                   let _ = snapshot.value as? [String: [String]] {
                    completed(.success(snapshot))
                    return
                }
                completed(.failure(FBDatabaseManagerError.snapShotNil))
            }
        }
    }
    
    public func setProfile(profile: Profile) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("CurrentUser is nil")
            return
        }
        profileChangeNotification(profile: profile)
        let ref = baseRef.child("User").child(uid).child("Srofile")
        let keyedValues = profileToKeyedValues(profile: profile)
        ref.setValue(keyedValues)
    }
    
    public func setStorage(mediaStorage: MediaStorage) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Current is nil")
            return
        }
        let ref = baseRef.child("User").child(uid).child("Storage")
        let movieStorageRef = ref.child("MovieStorage")
        let movieKeyedValues = storageToKeyedValues(myStorage: mediaStorage.movieStorage)
        movieStorageRef.setValue(movieKeyedValues)
    }
    
    private func profileToKeyedValues(profile: Profile) -> [String : String] {
        return [
            "nickname": profile.nickname,
            "introduction": profile.introduction,
            "profileimage": profile.profileImage
        ]
    }
    
    private func storageToKeyedValues(myStorage: MyStorage) -> [String : [String]] {
        return [
            "RatedStorage" : myStorage.ratedStorage,
            "WantedStorage" : myStorage.wantedStorage,
            "WatchingStorage" : myStorage.watchingStorage
        ]
    }
    
    private func profileChangeNotification(profile: Profile) {
        NotificationCenter.default.post(name: Notification.Name("setprofile"), object: profile)
    }
    
    private func storageChangeNotification(mediaStorage: MediaStorage) {
        NotificationCenter.default.post(name: Notification.Name("setstorage"), object: mediaStorage)
    }
    
}
