//
//  AuthViewModel.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation
import SwiftUI

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
    
    init() {
        // Check if user is already authenticated
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Methods
    func login() {
        guard validateLoginForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        let loginRequest = LoginRequest(
            email: loginEmail,
            password: loginPassword,
            rememberMe: rememberMe
        )
        
        // TODO: Implement actual API call
        // For now, simulate successful login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.isAuthenticated = true
            self.currentUser = User(
                id: UUID().uuidString,
                email: loginRequest.email,
                role: .researcher
            )
        }
    }
    
    func signUp() {
        guard validateSignupForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        let signupRequest = SignUpRequest(
            email: signupEmail,
            password: signupPassword,
            mobileNumber: signupMobileNumber,
            role: selectedRole
        )
        
        // TODO: Implement actual API call
        // For now, simulate successful signup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.isAuthenticated = true
            self.currentUser = User(
                id: UUID().uuidString,
                email: signupRequest.email,
                mobileNumber: signupRequest.mobileNumber,
                role: signupRequest.role
            )
        }
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement Google Sign-In
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.isAuthenticated = true
            self.currentUser = User(
                id: UUID().uuidString,
                email: "user@gmail.com",
                role: .researcher
            )
        }
    }
    
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        clearFormFields()
    }
    
    func forgotPassword() {
        // TODO: Implement forgot password functionality
        errorMessage = "Forgot password functionality will be implemented soon"
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
    
    private func checkAuthenticationStatus() {
        // TODO: Check for stored authentication token
        // For now, user starts as not authenticated
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
