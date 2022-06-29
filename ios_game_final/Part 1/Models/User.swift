//
//  User.swift
//  Part 1
//
//  
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    let email: String
    var money: Int
    let joinedDate: Date
    var avatarUrl: String?
}
