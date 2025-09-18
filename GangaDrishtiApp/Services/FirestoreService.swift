//
//  FirestoreService.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    let id: String
    let email: String
    let mobileNumber: String?
    let role: String
    let createdAt: Date
}

final class FirestoreService {
    static let shared = FirestoreService()
    private init() {}
    
    private var db: Firestore { Firestore.firestore() }
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        try db.collection("users").document(profile.id).setData(from: profile)
    }
    
    func fetchUserProfile(userId: String) async throws -> UserProfile? {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        return try snapshot.data(as: UserProfile?.self)
    }
}
