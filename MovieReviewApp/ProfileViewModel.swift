//
//  ProfileViewModel.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/13.
//

import KakaoSDKUser
import FirebaseDatabase

class ProfileViewModel {
    private var profile: Profile?
    private var ref = Database.database().reference().child("user")
    private let fbDatabaseManager: FBDataBaseManager = FBDataBaseManager()
    var viewUpdate: (() -> Void) = {}
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFirebaseProfile), name: Notification.Name("setprofile"), object: nil)
    }
    
    public func getProfile(completed: @escaping (Profile) -> ()) {
        if let profile = profile {
            return completed(profile)
        }
        firebaseProfile { profile in
            self.profile = profile
            completed(profile)
        }
    }
    
    private func firebaseProfile(completed: @escaping (Profile) -> ()) {
        fbDatabaseManager.getDataSnapshot(type: .profile) { result in
            switch  result {
            case .success(let snapshot):
                let profile = self.snapshotToProfile(snapshot: snapshot)
                completed(profile)
            case .failure(let failure):
                print(failure.localizedDescription)
                completed(Profile(nickname: "guest", profileImage: ""))
            }
        }
    }
    
    @objc
    private func setFirebaseProfile(_ notification: Notification) {
        guard let profile = notification.object as? Profile else { return }
        self.profile = profile
        viewUpdate()
    }
    
    private func snapshotToProfile(snapshot: DataSnapshot) -> Profile {
        guard let nickname = snapshot.value(forKey: "nickname") as? String,
              let introduction = snapshot.value(forKey: "introduction") as? String,
              let profileImage = snapshot.value(forKey: "profileimage") as? String else {
                  print("snapshot to profile error")
                  return profile ?? Profile(nickname: "guest", profileImage: "")
              }
        return Profile(nickname: nickname, introduction: introduction, profileImage: profileImage)
    }
    
    
}
