//
//  AuthViewModel.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Login form fields
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    @Published var rememberMe = false
    
    // Signup form fields
    @Published var signupEmail = ""
    @Published var signupPassword = ""
    @Published var signupMobileNumber = ""
    @Published var selectedRole: UserRole = .researcher
    
    // UI State
    @Published var isLoginMode = true
    @Published var showPassword = false
    @Published var showSignupPassword = false
    
    private let authService = AuthService.shared
    private let firestoreService = FirestoreService.shared
    
    init() {
        observeAuthState()
    }
    
    // MARK: - Authentication Methods
    func login() {
        guard validateLoginForm() else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fbUser = try await authService.signIn(email: loginEmail, password: loginPassword)
                try await postLoginSetup(firebaseUser: fbUser)
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signUp() {
        guard validateSignupForm() else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fbUser = try await authService.signUp(email: signupEmail, password: signupPassword)
                // Save profile to Firestore
                let profile = UserProfile(
                    id: fbUser.uid,
                    email: signupEmail,
                    mobileNumber: signupMobileNumber,
                    role: selectedRole.rawValue,
                    createdAt: Date()
                )
                try await firestoreService.saveUserProfile(profile)
                try await postLoginSetup(firebaseUser: fbUser)
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else {
            self.errorMessage = "Unable to access root view controller"
            self.isLoading = false
            return
        }
        
        Task {
            do {
                let fbUser = try await authService.signInWithGoogle(presenting: root)
                // Ensure Firestore profile exists; if not, create with default role
                let existing = try await firestoreService.fetchUserProfile(userId: fbUser.uid)
                if existing == nil {
                    let profile = UserProfile(
                        id: fbUser.uid,
                        email: fbUser.email ?? "",
                        mobileNumber: nil,
                        role: UserRole.researcher.rawValue,
                        createdAt: Date()
                    )
                    try await firestoreService.saveUserProfile(profile)
                }
                try await postLoginSetup(firebaseUser: fbUser)
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func logout() {
        do {
            try authService.signOut()
            isAuthenticated = false
            currentUser = nil
            clearFormFields()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        try await authService.sendPasswordReset(email: email)
    }
    
    // MARK: - Helpers
    private func postLoginSetup(firebaseUser: FirebaseAuth.User) async throws {
        // Load profile and map to app User
        let profile = try await firestoreService.fetchUserProfile(userId: firebaseUser.uid)
        let role = UserRole(rawValue: profile?.role ?? UserRole.researcher.rawValue) ?? .researcher
        let appUser = User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            mobileNumber: profile?.mobileNumber,
            role: role,
            isEmailVerified: firebaseUser.isEmailVerified
        )
        self.currentUser = appUser
        self.isAuthenticated = true
        self.isLoading = false
    }
    
    private func observeAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            Task { @MainActor in
                if let user = user {
                    do {
                        try await self.postLoginSetup(firebaseUser: user)
                    } catch {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                } else {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }
    
    // MARK: - Form Validation
    private func validateLoginForm() -> Bool {
        if loginEmail.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        
        if !isValidEmail(loginEmail) {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        if loginPassword.isEmpty {
            errorMessage = "Please enter your password"
            return false
        }
        
        if loginPassword.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
    
    private func validateSignupForm() -> Bool {
        if signupEmail.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        
        if !isValidEmail(signupEmail) {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        if signupPassword.isEmpty {
            errorMessage = "Please enter your password"
            return false
        }
        
        if signupPassword.count < 6 {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        if signupMobileNumber.isEmpty {
            errorMessage = "Please enter your mobile number"
            return false
        }
        
        if !isValidMobileNumber(signupMobileNumber) {
            errorMessage = "Please enter a valid mobile number"
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidMobileNumber(_ mobile: String) -> Bool {
        let mobileRegex = "^[0-9]{10}$"
        let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobilePredicate.evaluate(with: mobile)
    }
    
    private func clearFormFields() {
        loginEmail = ""
        loginPassword = ""
        rememberMe = false
        signupEmail = ""
        signupPassword = ""
        signupMobileNumber = ""
        selectedRole = .researcher
    }
}
