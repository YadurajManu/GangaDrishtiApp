//
//  AuthContainerView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct AuthContainerView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Background with starry pattern
            BackgroundView()
            
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 16) {
                    // Logo and App Name
                    HStack(spacing: 12) {
                        // App Logo
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        Text("GangaDrishti")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 60)
                    
                    // Title
                    Text("Get Started now")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Subtitle
                    Text("Create an account or log in to explore about our app")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
                
                // Auth Form Card
                VStack(spacing: 0) {
                    // Toggle Buttons
                    HStack(spacing: 0) {
                        ToggleButton(
                            title: "Log In",
                            isSelected: authViewModel.isLoginMode
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                authViewModel.isLoginMode = true
                            }
                        }
                        
                        ToggleButton(
                            title: "Sign Up",
                            isSelected: !authViewModel.isLoginMode
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                authViewModel.isLoginMode = false
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    
                    // Form Content
                    if authViewModel.isLoginMode {
                        LoginView(authViewModel: authViewModel)
                    } else {
                        SignUpView(authViewModel: authViewModel)
                    }
                    
                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
                        ErrorMessageView(message: errorMessage)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                    }
                    
                    Spacer(minLength: 20)
                }
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - Background View
struct BackgroundView: View {
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.9),
                    Color.blue.opacity(0.7),
                    Color.blue.opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Starry pattern overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    AuthContainerView()
}
