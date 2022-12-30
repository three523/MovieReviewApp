//
//  MyReactionModel.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/29.
//

import Foundation
import FirebaseDatabase

class MyReactionModel {
    static var shared: MyReactionModel = MyReactionModel()
    var myReactionList: MyReaction = MyReaction.empty
    private let firebaseManager: FBDataBaseManager = FBDataBaseManager()
    init() {
        firebaseManager.getDataSnapshot(type: .storage) { result in
            switch result {
            case .success(let dataSnapshot):
                print("ReactionModel: \(dataSnapshot)")
                self.myReactionList = self.dataSnapshotToReactionList(dataSnapshot: dataSnapshot)
                print("MyRectionList: \(self.myReactionList)")
            case .failure(let failure):
                print("ReactionModel failure")
                print(failure)
                self.myReactionList = MyReaction.empty
            }
        }
    }
    
    func addMediaInfo(mySummaryMediaInfo: SummaryMediaInfo, type: MediaReaction) {
        switch type {
        case .rated:
            guard let _ = myReactionList.rated else {
                myReactionList.rated = [mySummaryMediaInfo]
                firebaseManager.setReaction(mySummaryMediaInfos: [mySummaryMediaInfo.asDictionary], type: .rated)
                return }
            myReactionList.rated!.append(mySummaryMediaInfo)
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.rated!.map({ $0.asDictionary }), type: type)
        case .wanted:
            print("WantedMediaInfo: \(mySummaryMediaInfo)")
            guard let _ = myReactionList.wanted else {
                myReactionList.wanted = [mySummaryMediaInfo]
                firebaseManager.setReaction(mySummaryMediaInfos: [mySummaryMediaInfo.asDictionary], type: .wanted)
                return }
            myReactionList.wanted!.append(mySummaryMediaInfo)
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.wanted!.map({ $0.asDictionary }), type: type)
        case .watching:
            guard let _ = myReactionList.watching else {
                myReactionList.watching = [mySummaryMediaInfo]
                firebaseManager.setReaction(mySummaryMediaInfos: [mySummaryMediaInfo.asDictionary], type: .watching)
                return }
            myReactionList.watching!.append(mySummaryMediaInfo)
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.watching!.map({ $0.asDictionary }), type: type)
        }
    }
    
    func deleteMediaInfo(mySummaryMediaInfo: SummaryMediaInfo, type: MediaReaction) {
        switch type {
        case .rated:
            guard let _ = myReactionList.rated else { return }
            myReactionList.rated!.removeAll { $0.id == mySummaryMediaInfo.id }
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.rated!.map({ $0.asDictionary }), type: type)
        case .wanted:
            guard let _ = myReactionList.wanted else { return }
            myReactionList.wanted!.removeAll { $0.id == mySummaryMediaInfo.id }
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.wanted!.map({ $0.asDictionary }), type: type)
        case .watching:
            guard let _ = myReactionList.watching else { return }
            myReactionList.watching!.removeAll { $0.id == mySummaryMediaInfo.id }
            firebaseManager.setReaction(mySummaryMediaInfos: myReactionList.watching!.map({ $0.asDictionary }), type: type)
        }
    }
    
    private func dataSnapshotToReactionList(dataSnapshot: DataSnapshot) -> MyReaction {
        guard let dataSnapshot = dataSnapshot.value as? [String : Any] else {
            print("ReactionList is nil")
            return MyReaction.empty
        }
        let myReaction = dictionaryToObject(objectType: MyReaction.self, dictionary: dataSnapshot)
        return myReaction ?? MyReaction.empty
    }
    
    func dictionaryToObject<T:Decodable>(objectType: T.Type, dictionary: [String : Any]) -> T? {
        
        print("DictionaryToObject \(dictionary)")
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(objectType, from: dictionaries)
            print("object: \(object)")
            return object
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return nil
    }
}

