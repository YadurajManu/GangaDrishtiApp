//
//  AdminDashboardView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct AdminDashboardView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Admin Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("System Management & Monitoring")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quick Actions
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
                    
                    Button(action: {}) {
                        Image(systemName: "gear")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            // Tab Selector
            Picker("View", selection: $selectedTab) {
                Text("Heatmap").tag(0)
                Text("Live Feed").tag(1)
                Text("Samples").tag(2)
                Text("Analytics").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Content
            TabView(selection: $selectedTab) {
                // Heatmap View
                HeatmapView()
                    .tag(0)
                
                // Live Feed View
                LiveFeedView()
                    .tag(1)
                
                // Samples Management View
                SamplesManagementView()
                    .tag(2)
                
                // Analytics View
                AdminAnalyticsView()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(Color(.systemGroupedBackground))
    }
}


// MARK: - Samples Management View
struct SamplesManagementView: View {
    @StateObject private var dataManager = HeatmapDataManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Sample Management")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Sample")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Sample List
                LazyVStack(spacing: 12) {
                    ForEach(dataManager.samples.prefix(10)) { sample in
                        SampleCard(sample: sample)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Sample Card
struct SampleCard: View {
    let sample: MicroplasticSample
    
    var body: some View {
        HStack {
            // Sample Info
            VStack(alignment: .leading, spacing: 4) {
                Text(sample.locationName)
                    .font(.headline)
                
                Text("ID: \(sample.id.prefix(8))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(sample.microplasticType.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(sample.microplasticType.color).opacity(0.2))
                        .foregroundColor(Color(sample.microplasticType.color))
                        .cornerRadius(4)
                    
                    Text("\(Int(sample.intensity))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(intensityColor.opacity(0.2))
                        .foregroundColor(intensityColor)
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            // Actions
            VStack(spacing: 8) {
                Button(action: {}) {
                    Image(systemName: "eye")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Button(action: {}) {
                    Image(systemName: "trash")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var intensityColor: Color {
        let intensity = sample.intensity
        if intensity < 20 { return .green }
        else if intensity < 40 { return .yellow }
        else if intensity < 60 { return .orange }
        else if intensity < 80 { return .red }
        else { return .purple }
    }
}

// MARK: - Admin Analytics View
struct AdminAnalyticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // System Stats
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    AdminStatCard(title: "Total Samples", value: "24", color: .blue, icon: "flask.fill")
                    AdminStatCard(title: "Active Cameras", value: "3", color: .green, icon: "camera.fill")
                    AdminStatCard(title: "Pending Analysis", value: "5", color: .orange, icon: "clock.fill")
                    AdminStatCard(title: "System Uptime", value: "99.8%", color: .purple, icon: "server.rack")
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        ActivityRow(icon: "plus.circle.fill", title: "New sample added", time: "2 min ago", color: .green)
                        ActivityRow(icon: "camera.fill", title: "Image captured", time: "5 min ago", color: .blue)
                        ActivityRow(icon: "checkmark.circle.fill", title: "Analysis completed", time: "12 min ago", color: .green)
                        ActivityRow(icon: "exclamationmark.triangle.fill", title: "High pollution detected", time: "1 hour ago", color: .red)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

// MARK: - Admin Stat Card
struct AdminStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Activity Row
struct ActivityRow: View {
    let icon: String
    let title: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    AdminDashboardView()
}
