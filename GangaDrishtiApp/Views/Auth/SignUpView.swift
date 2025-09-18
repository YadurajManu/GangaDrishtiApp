//
//  SignUpView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Email Field
            CustomTextField(
                title: "Email",
                placeholder: "Enter your email",
                text: $authViewModel.signupEmail,
                keyboardType: .emailAddress
            )
            
            // Password Field
            CustomTextField(
                title: "Password",
                placeholder: "Enter your password",
                text: $authViewModel.signupPassword,
                isSecure: true,
                showPassword: authViewModel.showSignupPassword,
                onTogglePassword: {
                    authViewModel.showSignupPassword.toggle()
                }
            )
            
            // Mobile Number Field
            CustomTextField(
                title: "Mobile Number",
                placeholder: "Enter your mobile number",
                text: $authViewModel.signupMobileNumber,
                keyboardType: .phonePad
            )
            
            // Role Selection
            ModernRoleSelector(selectedRole: $authViewModel.selectedRole)
            
            // Sign Up Button
            CustomButton(
                title: "Sign Up",
                action: {
                    authViewModel.signUp()
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
            GoogleSignInButton {
                authViewModel.signInWithGoogle()
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    SignUpView(authViewModel: AuthViewModel())
        .background(Color.white)
}
