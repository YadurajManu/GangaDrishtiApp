//
//  LoginView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showForgotPassword = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Email Field
            CustomTextField(
                title: "Email",
                placeholder: "Enter your email",
                text: $authViewModel.loginEmail,
                keyboardType: .emailAddress
            )
            
            // Password Field
            CustomTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: $authViewModel.loginPassword,
                isSecure: true,
                showPassword: authViewModel.showPassword,
                onTogglePassword: {
                    authViewModel.showPassword.toggle()
                }
            )
            
            // Remember Me and Forgot Password
            HStack {
                Checkbox(
                    isChecked: $authViewModel.rememberMe,
                    title: "Remember me"
                )
                
                Spacer()
                
                Button(action: {
                    showForgotPassword = true
                }) {
                    Text("Forgot Password ?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            // Login Button
            CustomButton(
                title: "Log In",
                action: {
                    authViewModel.login()
                },
                isLoading: authViewModel.isLoading
            )
            
            // Or Separator
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text("Or")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.vertical, 8)
            
            // Google Sign-In Button
            GoogleSignInButton(action: {
                authViewModel.signInWithGoogle()
            })
        }
        .padding(.horizontal, 24)
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
                .presentationDetents([.fraction(0.92)])
                .presentationCornerRadius(24)
                .presentationDragIndicator(.visible) // allow swipe down dismissal
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthViewModel())
        .background(Color.white)
}
