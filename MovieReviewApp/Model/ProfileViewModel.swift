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
        NotificationCenter.default.addObserver(self, selector: #selector(setFirebaseProfileObserver), name: Notification.Name("setprofile"), object: nil)
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
    
    public func setProfile(profile: Profile) {
        self.profile = profile
        fbDatabaseManager.setProfile(profile: profile)
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
    private func setFirebaseProfileObserver(_ notification: Notification) {
        guard let profile = notification.object as? Profile else { return }
        self.profile = profile
        viewUpdate()
    }
    
    private func snapshotToProfile(snapshot: DataSnapshot) -> Profile {
        guard let profile = snapshot.value as? [String: String],
              let nickname = profile["nickname"],
              let introduction = profile["introduction"],
              let profileImage = profile["profileimage"] else {
                  print("snapshot to profile error")
                  return profile ?? Profile(nickname: "guest", profileImage: "")
              }
        return Profile(nickname: nickname, introduction: introduction, profileImage: profileImage)
    }
    
}
