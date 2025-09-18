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
        VStack(spacing: 0) {
            // Simple top bar
            HStack {
                Text("GangaDrishti")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button("Logout") {
                    authViewModel.logout()
                }
                .padding(8)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(Color(.secondarySystemBackground))

            // Role-based dashboard placeholder
            Group {
                if let user = authViewModel.currentUser {
                    switch user.role {
                    case .admin:
                        AdminDashboardView()
                    case .government:
                        GovernmentDashboardView()
                    case .researcher:
                        ResearcherDashboardView()
                    }
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("Unknown User")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
