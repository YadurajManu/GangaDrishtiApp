//
//  GovernmentDashboardView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct GovernmentDashboardView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Government Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Microplastic Pollution Analysis")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Stats Summary
                HStack(spacing: 16) {
                    StatCard(title: "Total Samples", value: "24", color: .blue)
                    StatCard(title: "High Risk", value: "8", color: .red)
                    StatCard(title: "Moderate", value: "12", color: .orange)
                    StatCard(title: "Low Risk", value: "4", color: .green)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            // Tab Selector
            Picker("View", selection: $selectedTab) {
                Text("Heatmap").tag(0)
                Text("Analytics").tag(1)
                Text("Reports").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            // Content
            TabView(selection: $selectedTab) {
                // Heatmap View
                HeatmapView()
                    .tag(0)
                
                // Analytics View
                AnalyticsView()
                    .tag(1)
                
                // Reports View
                ReportsView()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Analytics View
struct AnalyticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Charts placeholder
                VStack(spacing: 16) {
                    Text("Pollution Trends")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                                Text("Trend Chart")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                
                // Summary cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    SummaryCard(title: "Peak Pollution", value: "Industrial Zone C", color: .red)
                    SummaryCard(title: "Cleanest Area", value: "City Park", color: .green)
                    SummaryCard(title: "Avg Intensity", value: "62%", color: .orange)
                    SummaryCard(title: "Samples Today", value: "3", color: .blue)
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Reports View
struct ReportsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<5) { index in
                    ReportCard(
                        title: "Weekly Report \(index + 1)",
                        date: Date().addingTimeInterval(-Double(index * 7 * 24 * 60 * 60)),
                        status: ["Draft", "Published", "Pending"].randomElement() ?? "Draft"
                    )
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Report Card
struct ReportCard: View {
    let title: String
    let date: Date
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .cornerRadius(6)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var statusColor: Color {
        switch status {
        case "Published": return .green
        case "Draft": return .orange
        case "Pending": return .blue
        default: return .gray
        }
    }
}

#Preview {
    GovernmentDashboardView()
}
