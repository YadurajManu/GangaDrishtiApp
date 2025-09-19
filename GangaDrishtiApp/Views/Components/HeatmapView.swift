//
//  HeatmapView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI
import MapKit

struct HeatmapView: View {
    @StateObject private var dataManager = HeatmapDataManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 28.421, longitude: 77.523),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
    )
    @State private var selectedSample: MicroplasticSample?
    @State private var showFilters = false
    
    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region, 
                annotationItems: dataManager.filteredSamples) { sample in
                MapAnnotation(coordinate: sample.coordinate) {
                    HeatmapCircle(sample: sample)
                        .onTapGesture {
                            selectedSample = sample
                        }
                }
            }
            .ignoresSafeArea()
            
            // Top Controls
            VStack {
                HStack {
                    // Campus Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GBU Campus & Surroundings")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Microplastic Pollution Analysis")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Filter Button
                    Button(action: { showFilters.toggle() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .font(.title3)
                            Text("Filter")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // Enhanced Legend
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Pollution Intensity")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ForEach(0..<6) { index in
                                VStack(spacing: 2) {
                                    Circle()
                                        .fill(heatmapColor(for: Double(index * 20)))
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                    
                                    Text("\(index * 20)%")
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // Campus Stats
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Campus Stats")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            VStack(spacing: 2) {
                                Text("\(dataManager.filteredSamples.count)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Samples")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            VStack(spacing: 2) {
                                Text("\(Int(dataManager.filteredSamples.map(\.intensity).reduce(0, +) / Double(max(dataManager.filteredSamples.count, 1))))%")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Avg Risk")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            
            // Sample Detail Sheet
            if let sample = selectedSample {
                SampleDetailSheet(sample: sample) {
                    selectedSample = nil
                }
            }
            
            // Filter Sheet
            if showFilters {
                FilterSheet(dataManager: dataManager) {
                    showFilters = false
                }
            }
        }
    }
    
    private func heatmapColor(for intensity: Double) -> Color {
        let normalizedIntensity = intensity / 100.0
        
        if normalizedIntensity < 0.2 {
            return .green
        } else if normalizedIntensity < 0.4 {
            return .yellow
        } else if normalizedIntensity < 0.6 {
            return .orange
        } else if normalizedIntensity < 0.8 {
            return .red
        } else {
            return .purple
        }
    }
}

// MARK: - Heatmap Circle
struct HeatmapCircle: View {
    let sample: MicroplasticSample
    
    var body: some View {
        let intensity = sample.intensity
        let normalizedIntensity = min(1.0, intensity / 100.0)
        let size = CGFloat(24 + (normalizedIntensity * 36)) // 24-60 points
        
        ZStack {
            // Outer glow effect
            Circle()
                .fill(heatmapColor(for: intensity))
                .opacity(0.3)
                .frame(width: size + 8, height: size + 8)
                .blur(radius: 4)
            
            // Main circle
            Circle()
                .fill(heatmapColor(for: intensity))
                .opacity(0.8)
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .overlay(
                    // Intensity percentage
                    Text("\(Int(intensity))%")
                        .font(.system(size: min(12, size * 0.3), weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 1)
                )
                .shadow(color: heatmapColor(for: intensity).opacity(0.6), radius: 6, x: 0, y: 2)
        }
    }
    
    private func heatmapColor(for intensity: Double) -> Color {
        let normalizedIntensity = intensity / 100.0
        
        if normalizedIntensity < 0.2 {
            return .green
        } else if normalizedIntensity < 0.4 {
            return .yellow
        } else if normalizedIntensity < 0.6 {
            return .orange
        } else if normalizedIntensity < 0.8 {
            return .red
        } else {
            return .purple
        }
    }
}

// MARK: - Sample Detail Sheet
struct SampleDetailSheet: View {
    let sample: MicroplasticSample
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Minimal Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 36, height: 3)
                .padding(.top, 12)
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(sample.locationName)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Sample \(sample.id.prefix(6))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(width: 28, height: 28)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                // Risk Indicator
                HStack {
                    Circle()
                        .fill(riskColor)
                        .frame(width: 12, height: 12)
                    
                    Text(riskLevel)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(sample.intensity))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(heatmapColor(for: sample.intensity))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(riskColor.opacity(0.1))
                .cornerRadius(12)
                
                // Key Metrics
                VStack(spacing: 16) {
                    MinimalMetricRow(
                        icon: "circle.grid.3x3.fill",
                        title: "Particles",
                        value: "\(sample.particleCount)",
                        color: .blue
                    )
                    
                    MinimalMetricRow(
                        icon: "flask.fill",
                        title: "Type",
                        value: sample.microplasticType.rawValue,
                        color: Color(sample.microplasticType.color)
                    )
                    
                    MinimalMetricRow(
                        icon: "calendar",
                        title: "Date",
                        value: sample.sampleDate.formatted(date: .abbreviated, time: .omitted),
                        color: .gray
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
        .frame(height: 280)
        .transition(.move(edge: .bottom))
    }
    
    private var riskLevel: String {
        let intensity = sample.intensity
        if intensity < 20 { return "Low" }
        else if intensity < 40 { return "Moderate" }
        else if intensity < 60 { return "High" }
        else if intensity < 80 { return "Very High" }
        else { return "Critical" }
    }
    
    private var riskColor: Color {
        let intensity = sample.intensity
        if intensity < 20 { return .green }
        else if intensity < 40 { return .yellow }
        else if intensity < 60 { return .orange }
        else if intensity < 80 { return .red }
        else { return .purple }
    }
    
    private var locationType: String {
        let name = sample.locationName.lowercased()
        if name.contains("lab") || name.contains("research") { return "Research Facility" }
        else if name.contains("hostel") || name.contains("student") { return "Student Area" }
        else if name.contains("sports") || name.contains("gym") { return "Sports Facility" }
        else if name.contains("garden") || name.contains("pond") { return "Green Area" }
        else if name.contains("parking") || name.contains("road") { return "High Traffic Area" }
        else if name.contains("construction") || name.contains("maintenance") { return "Construction Zone" }
        else { return "Academic Building" }
    }
    
    private func heatmapColor(for intensity: Double) -> Color {
        let normalizedIntensity = intensity / 100.0
        
        if normalizedIntensity < 0.2 {
            return .green
        } else if normalizedIntensity < 0.4 {
            return .yellow
        } else if normalizedIntensity < 0.6 {
            return .orange
        } else if normalizedIntensity < 0.8 {
            return .red
        } else {
            return .purple
        }
    }
}

// MARK: - Minimal Metric Row
struct MinimalMetricRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Filter Sheet
struct FilterSheet: View {
    @ObservedObject var dataManager: HeatmapDataManager
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Filter Samples")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Intensity Range
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity Range: \(Int(dataManager.selectedIntensityRange.lowerBound)) - \(Int(dataManager.selectedIntensityRange.upperBound))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    HStack {
                        Text("0")
                        Slider(value: Binding(
                            get: { dataManager.selectedIntensityRange.lowerBound },
                            set: { newValue in
                                dataManager.updateIntensityRange(newValue...dataManager.selectedIntensityRange.upperBound)
                            }
                        ), in: 0...100)
                        Text("100")
                    }
                }
                
                // Microplastic Types
                VStack(alignment: .leading, spacing: 8) {
                    Text("Microplastic Types")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(MicroplasticType.allCases, id: \.self) { type in
                            Button(action: {
                                if dataManager.selectedMicroplasticTypes.contains(type) {
                                    dataManager.selectedMicroplasticTypes.remove(type)
                                } else {
                                    dataManager.selectedMicroplasticTypes.insert(type)
                                }
                                dataManager.applyFilters()
                            }) {
                                HStack {
                                    Circle()
                                        .fill(Color(type.color))
                                        .frame(width: 8, height: 8)
                                    
                                    Text(type.rawValue)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    dataManager.selectedMicroplasticTypes.contains(type) ? 
                                    Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
                                )
                                .cornerRadius(8)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
        .frame(height: 400)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    HeatmapView()
}
