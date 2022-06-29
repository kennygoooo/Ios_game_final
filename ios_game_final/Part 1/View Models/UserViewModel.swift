//
//  UserViewModel.swift
//  Part 1
//
//
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    @Published var user = User(id: nil, name: "loading...", email: "loading...", money: 200, joinedDate: Date.now)
    @Published var usersForLeaderBoard : [User] = []
    
    func listenToUserDataChange(id: String) {
        let db = Firestore.firestore()
        db.collection("users").document(id).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            guard (try? snapshot.data(as: User.self)) != nil else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.user = user
        }
    }
    
    func updateUser(name: String, avatarUrl: String?) {
        let db = Firestore.firestore()
        let documentReference = db.collection("users").document(user.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var user = try? document.data(as: User.self) else { return }
            user.name = name
            if let avatarUrl = avatarUrl {
                user.avatarUrl = avatarUrl
            }
            do {
                try documentReference.setData(from: user)
            } catch {
                print(error)
            }
        }
    }
    
    func getReward() {
        let db = Firestore.firestore()
        let documentReference = db.collection("users").document(user.id!)
        documentReference.getDocument { document, error in
            guard let document = document, document.exists, var user = try? document.data(as: User.self) else { return }
            user.money += 500
            do {
                try documentReference.setData(from: user)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchUserForLeaderBoard() {
        let db = Firestore.firestore()
        db.collection("users").order(by: "money", descending: true).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: User.self)
            }
            self.usersForLeaderBoard = users
        }
    }
}
