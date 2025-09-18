//
//  AuthService.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import UIKit

final class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    // MARK: - Current User
    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Email/Password
    func signUp(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presenting presentingViewController: UIViewController) async throws -> FirebaseAuth.User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Google Client ID"])
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let gidUser: GIDGoogleUser = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<GIDGoogleUser, Error>) in
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let user = result?.user else {
                    continuation.resume(throwing: NSError(domain: "AuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In failed"]))
                    return
                }
                continuation.resume(returning: user)
            }
        }
        
        guard let idToken = gidUser.idToken else {
            throw NSError(domain: "AuthService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Missing idToken"])
        }
        
        let accessToken = gidUser.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        let result = try await Auth.auth().signIn(with: credential)
        return result.user
    }
}
