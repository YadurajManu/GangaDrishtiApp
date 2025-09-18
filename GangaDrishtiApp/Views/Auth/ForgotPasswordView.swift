//
//  ForgotPasswordView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var showSuccessMessage = false
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // White background instead of blue
            Color.white
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.08))
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        .padding(.top, 14)

                        Image(systemName: "lock.rotation")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(.blue)
                            .scaleEffect(isAnimating ? 1.05 : 0.95)
                            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isAnimating)

                        Text("Forgot Password?")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text("Don't worry! Enter your email address and we'll send you a reset link.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 24)

                    // Card
                    VStack(spacing: 20) {
                        if showSuccessMessage {
                            VStack(spacing: 16) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 54))
                                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.55, dampingFraction: 0.75), value: isAnimating)

                                Text("Email Sent")
                                    .font(.system(size: 22, weight: .semibold))

                                Text("We've sent a password reset link to your email. Please check your inbox.")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)

                                CustomButton(
                                    title: "Back to Login",
                                    action: { dismiss() },
                                    isLoading: false,
                                    isEnabled: true,
                                    backgroundColor: .blue
                                )
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 16) {
                                CustomTextField(
                                    title: "Email Address",
                                    placeholder: "Enter your email address",
                                    text: $email,
                                    keyboardType: .emailAddress
                                )

                                CustomButton(
                                    title: "Send Reset Link",
                                    action: {
                                        Task { await sendResetLink() }
                                    },
                                    isLoading: authViewModel.isLoading,
                                    isEnabled: !email.isEmpty && isValidEmail(email),
                                    backgroundColor: .blue
                                )

                                Button(action: { dismiss() }) {
                                    Text("Back to Login")
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .foregroundColor(.blue)
                                .padding(.top, 4)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.blue.opacity(0.06))
                            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .frame(maxWidth: 520)
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear { isAnimating = true }
        .alert("Error", isPresented: .constant(authViewModel.errorMessage != nil)) {
            Button("OK") { authViewModel.errorMessage = nil }
        } message: { Text(authViewModel.errorMessage ?? "") }
    }
    
    // MARK: - Methods
    private func sendResetLink() async {
        guard isValidEmail(email) else {
            authViewModel.errorMessage = "Please enter a valid email address"
            return
        }
        
        do {
            try await authViewModel.sendPasswordReset(email: email)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showSuccessMessage = true
            }
        } catch {
            authViewModel.errorMessage = error.localizedDescription
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    ForgotPasswordView()
}
