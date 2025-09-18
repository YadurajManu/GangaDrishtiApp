//
//  User.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let mobileNumber: String?
    let role: UserRole
    let createdAt: Date
    let isEmailVerified: Bool
    
    init(id: String, email: String, mobileNumber: String? = nil, role: UserRole = .researcher, isEmailVerified: Bool = false) {
        self.id = id
        self.email = email
        self.mobileNumber = mobileNumber
        self.role = role
        self.createdAt = Date()
        self.isEmailVerified = isEmailVerified
    }
}

enum UserRole: String, CaseIterable, Codable {
    case admin = "admin"
    case government = "government"
    case researcher = "researcher"
    
    var displayName: String {
        switch self {
        case .admin:
            return "Administrator"
        case .government:
            return "Government Official"
        case .researcher:
            return "Researcher"
        }
    }
}

// MARK: - Authentication Models
struct LoginRequest {
    let email: String
    let password: String
    let rememberMe: Bool
}

struct SignUpRequest {
    let email: String
    let password: String
    let mobileNumber: String
    let role: UserRole
}

struct AuthResponse {
    let user: User
    let token: String
    let refreshToken: String
}
