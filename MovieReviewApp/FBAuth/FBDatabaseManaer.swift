//
//  FBDB.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/14.
//

import FirebaseDatabase
import FirebaseAuth

enum FireBaseDataType {
    case profile
}

final class FBDataBaseManager {
    static let `default`: FBDataBaseManager = FBDataBaseManager()
    private let baseRef: DatabaseReference = Database.database().reference()
    
    public func getDataSnapshot(type: FireBaseDataType, completed: @escaping (Result<DataSnapshot,Error>) -> ()) {
        switch type {
        case .profile:
            guard let uid = Auth.auth().currentUser?.uid else {
                completed(.failure(FBDatabaseManagerError.emailNil))
                return
            }
            let ref = baseRef.child("user").child(uid)
            ref.getData { error, snapshot in
                if let error = error {
                    completed(.failure(error))
                    return
                }
                if let snapshot = snapshot {
                    completed(.success(snapshot))
                    return
                }
                completed(.failure(FBDatabaseManagerError.snapShotNil))
            }
        }
    }
    
    public func setProfile(profile: Profile) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("email is nil")
            return
        }
        profileChangeNotification(profile: profile)
        let ref = baseRef.child("user").child(uid).child("profile")
        let keyedValues = profileToKeyedValues(profile: profile)
        ref.onDisconnectSetValue(keyedValues)
    }
    
    private func profileToKeyedValues(profile: Profile) -> [String : String] {
        return [
            "nickname": profile.nickname,
            "introduction": profile.introduction,
            "profileimage": profile.profileImage
        ]
    }
    
    private func profileChangeNotification(profile: Profile) {
        NotificationCenter.default.post(name: Notification.Name("setprofile"), object: profile)
    }
    
}
