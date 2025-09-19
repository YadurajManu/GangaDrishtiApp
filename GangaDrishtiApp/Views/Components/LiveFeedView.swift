//
//  LiveFeedView.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import SwiftUI
import PhotosUI

struct LiveFeedView: View {
    @State private var isShowingCamera = false
    @State private var capturedImage: UIImage?
    @State private var isShowingPreview = false
    @State private var isAnalyzing = false
    @State private var analysisResult: AnalysisResult?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Microscope Feed")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Capture and analyze microplastic samples")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status Indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(capturedImage != nil ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(capturedImage != nil ? "READY" : "LIVE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(capturedImage != nil ? .green : .red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            // Main Content
            if isShowingPreview {
                AnalysisPreviewView(
                    image: capturedImage!,
                    isAnalyzing: $isAnalyzing,
                    analysisResult: $analysisResult,
                    onRetake: {
                        capturedImage = nil
                        isShowingPreview = false
                    },
                    onAnalyze: {
                        performAnalysis()
                    }
                )
            } else {
                CameraView(
                    capturedImage: $capturedImage,
                    isShowingPreview: $isShowingPreview
                )
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func performAnalysis() {
        isAnalyzing = true
        
        // Simulate analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Generate mock analysis result
            analysisResult = AnalysisResult(
                microplasticCount: Int.random(in: 50...500),
                confidence: Double.random(in: 0.7...0.95),
                particleTypes: ["PE", "PP", "PS"].shuffled().prefix(2).map { $0 },
                riskLevel: ["Low", "Moderate", "High"].randomElement() ?? "Moderate",
                recommendations: [
                    "Sample shows moderate microplastic contamination",
                    "Recommend further testing in surrounding areas",
                    "Consider implementing filtration measures"
                ]
            )
            isAnalyzing = false
        }
    }
}

// MARK: - Camera View
struct CameraView: View {
    @Binding var capturedImage: UIImage?
    @Binding var isShowingPreview: Bool
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Camera Preview Area
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.8))
                .frame(height: 400)
                .overlay(
                    VStack(spacing: 16) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Microscope Camera Feed")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("Position your sample under the microscope")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                )
                .padding(.horizontal, 20)
            
            // Capture Controls
            VStack(spacing: 16) {
                // Primary Capture Button
                Button(action: {
                    isShowingCamera = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                        Text("Capture Photo")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                
                // Alternative Options
                HStack(spacing: 16) {
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                            Text("Choose from Gallery")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "video.fill")
                            Text("Record Video")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $capturedImage, isShowingPreview: $isShowingPreview)
        }
        .sheet(isPresented: $isShowingCamera) {
            CameraPicker(selectedImage: $capturedImage, isShowingPreview: $isShowingPreview)
        }
    }
}

// MARK: - Analysis Preview View
struct AnalysisPreviewView: View {
    let image: UIImage
    @Binding var isAnalyzing: Bool
    @Binding var analysisResult: AnalysisResult?
    let onRetake: () -> Void
    let onAnalyze: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Preview Header
            HStack {
                Button(action: onRetake) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left")
                        Text("Retake")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("Photo Preview")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Image Preview
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 300)
                        .overlay(
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                        )
                        .padding(.horizontal, 20)
                    
                    // Analysis Button
                    if analysisResult == nil {
                        Button(action: onAnalyze) {
                            HStack(spacing: 12) {
                                if isAnalyzing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                }
                                
                                Text(isAnalyzing ? "Analyzing..." : "Run Analysis")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: isAnalyzing ? [.gray, .gray.opacity(0.8)] : [.green, .green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .disabled(isAnalyzing)
                        .padding(.horizontal, 20)
                    }
                    
                    // Analysis Results
                    if let result = analysisResult {
                        AnalysisResultsView(result: result)
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
}

// MARK: - Analysis Results View
struct AnalysisResultsView: View {
    let result: AnalysisResult
    
    var body: some View {
        VStack(spacing: 16) {
            // Results Header
            HStack {
                Text("Analysis Results")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Completed")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(4)
            }
            .padding(.horizontal, 20)
            
            // Results Cards
            VStack(spacing: 12) {
                ResultCard(
                    title: "Microplastic Count",
                    value: "\(result.microplasticCount) particles",
                    color: .blue,
                    icon: "circle.grid.3x3.fill"
                )
                
                ResultCard(
                    title: "Confidence Level",
                    value: "\(Int(result.confidence * 100))%",
                    color: .purple,
                    icon: "checkmark.seal.fill"
                )
                
                ResultCard(
                    title: "Risk Level",
                    value: result.riskLevel,
                    color: riskColor,
                    icon: "exclamationmark.triangle.fill"
                )
                
                ResultCard(
                    title: "Particle Types",
                    value: result.particleTypes.joined(separator: ", "),
                    color: .orange,
                    icon: "flask.fill"
                )
            }
            .padding(.horizontal, 20)
            
            // Recommendations
            VStack(alignment: .leading, spacing: 12) {
                Text("Recommendations")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(result.recommendations, id: \.self) { recommendation in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .font(.subheadline)
                                .foregroundColor(.yellow)
                                .frame(width: 16)
                            
                            Text(recommendation)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var riskColor: Color {
        switch result.riskLevel {
        case "Low": return .green
        case "Moderate": return .orange
        case "High": return .red
        default: return .gray
        }
    }
}

// MARK: - Result Card
struct ResultCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingPreview: Bool
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        self.parent.isShowingPreview = true
                    }
                }
            }
        }
    }
}

// MARK: - Camera Picker
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingPreview: Bool
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            
            parent.isShowingPreview = true
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Analysis Result Model
struct AnalysisResult {
    let microplasticCount: Int
    let confidence: Double
    let particleTypes: [String]
    let riskLevel: String
    let recommendations: [String]
}

#Preview {
    LiveFeedView()
}
