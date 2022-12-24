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
    private var mediaStorage: MediaStorage?
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
    
    public func getStorage(completed: @escaping (MediaStorage) -> ()) {
        if let mediaStorage = mediaStorage {
            completed(mediaStorage)
        }
        firebaseStorage { mediaStorage in
            self.mediaStorage = mediaStorage
            completed(mediaStorage)
        }
    }
    
    public func setProfile(profile: Profile) {
        getProfile { previousProfile in
            FBStorageManager.deleteImage(urlString: previousProfile.profileImage) {
                self.profile = profile
                self.fbDatabaseManager.setProfile(profile: profile)
            }
        }
    }
    
    public func setStorage(mediaStorage: MediaStorage) {
        self.mediaStorage = mediaStorage
        self.fbDatabaseManager.setStorage(mediaStorage: mediaStorage)
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
    
    private func firebaseStorage(completed: @escaping (MediaStorage) -> ()) {
        fbDatabaseManager.getDataSnapshot(type: .storage) { result in
            switch  result {
            case .success(let snapshot):
                let mediaStorage = self.snapshotToStorage(snapshot: snapshot)
                completed(mediaStorage)
            case .failure(let failure):
                print(failure.localizedDescription)
                completed(MediaStorage.empty)
            }
        }
    }
    
    @objc
    private func setFirebaseProfileObserver(_ notification: Notification) {
        guard let profile = notification.object as? Profile else { return }
        self.profile = profile
        viewUpdate()
    }
    
    @objc
    private func setFirebaseStorageObserver(_ notification: Notification) {
        guard let mediaStorage = notification.object as? MediaStorage else { return }
        self.mediaStorage = mediaStorage
        viewUpdate()
    }
    
    private func snapshotToProfile(snapshot: DataSnapshot) -> Profile {
        guard let profile = snapshot.value as? [String : String],
              let nickname = profile["nickname"],
              let introduction = profile["introduction"],
              let profileImage = profile["profileimage"] else {
                  print("snapshot to profile error")
                  return profile ?? Profile(nickname: "guest", profileImage: "")
              }
        return Profile(nickname: nickname, introduction: introduction, profileImage: profileImage)
    }
    
    private func snapshotToStorage(snapshot: DataSnapshot) -> MediaStorage {
        guard let movieStorage = snapshot.value as? [String : [String]],
              let ratedStorage = movieStorage["RatedStorage"],
              let wantedStorage = movieStorage["WantedStorage"],
              let watchingStorage = movieStorage["WatchingStorge"]
        else {
            print("Snapshot to Storage Error")
            return MediaStorage.empty
        }
        let myStorage = MyStorage(ratedStorage: ratedStorage, wantedStorage: wantedStorage, watchingStorage: watchingStorage)
        return MediaStorage(movieStorage: myStorage)
    }
    
}
