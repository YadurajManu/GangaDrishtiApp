//
//  ResearcherDashboardView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI

struct ResearcherDashboardView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Researcher Dashboard")
                .font(.system(size: 28, weight: .bold))
            Text("Placeholder UI. Feature implementation coming soon.")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ResearcherDashboardView()
}
