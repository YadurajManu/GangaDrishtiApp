//
//  ContentView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // Main App Content (to be implemented)
                MainAppView()
            } else {
                // Authentication Screen
                AuthContainerView()
            }
        }
        .environmentObject(authViewModel)
    }
}

// MARK: - Main App View (Placeholder)
struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Welcome to GangaDrishti!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("You are successfully logged in.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if let user = authViewModel.currentUser {
                Text("Logged in as: \(user.email)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Button("Logout") {
                authViewModel.logout()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
