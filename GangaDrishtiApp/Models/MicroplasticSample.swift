//
//  MicroplasticSample.swift
//  GangaDrishtiApp
//
//  Created by Yaduraj Singh on 15/09/25.
//

import Foundation
import MapKit

struct MicroplasticSample: Identifiable, Codable {
    let id: String
    let latitude: Double
    let longitude: Double
    let intensity: Double // 0-100 scale
    let microplasticType: MicroplasticType
    let particleCount: Int
    let sampleDate: Date
    let locationName: String
    let collectedBy: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(id: String = UUID().uuidString, 
         latitude: Double, 
         longitude: Double, 
         intensity: Double, 
         microplasticType: MicroplasticType = .random(),
         particleCount: Int = Int.random(in: 10...500),
         sampleDate: Date = Date(),
         locationName: String = "",
         collectedBy: String = "Admin") {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.intensity = intensity
        self.microplasticType = microplasticType
        self.particleCount = particleCount
        self.sampleDate = sampleDate
        self.locationName = locationName
        self.collectedBy = collectedBy
    }
}

enum MicroplasticType: String, CaseIterable, Codable {
    case polyethylene = "PE"
    case polypropylene = "PP"
    case polystyrene = "PS"
    case polyvinylchloride = "PVC"
    case polyethyleneTerephthalate = "PET"
    case polyamide = "PA"
    
    var displayName: String {
        switch self {
        case .polyethylene: return "Polyethylene (PE)"
        case .polypropylene: return "Polypropylene (PP)"
        case .polystyrene: return "Polystyrene (PS)"
        case .polyvinylchloride: return "PVC"
        case .polyethyleneTerephthalate: return "PET"
        case .polyamide: return "Polyamide (PA)"
        }
    }
    
    var color: String {
        switch self {
        case .polyethylene: return "blue"
        case .polypropylene: return "red"
        case .polystyrene: return "yellow"
        case .polyvinylchloride: return "green"
        case .polyethyleneTerephthalate: return "orange"
        case .polyamide: return "purple"
        }
    }
    
    static func random() -> MicroplasticType {
        return allCases.randomElement() ?? .polyethylene
    }
}

// MARK: - Heatmap Data Manager
class HeatmapDataManager: ObservableObject {
    @Published var samples: [MicroplasticSample] = []
    @Published var filteredSamples: [MicroplasticSample] = []
    @Published var selectedIntensityRange: ClosedRange<Double> = 0...100
    @Published var selectedDateRange: ClosedRange<Date> = Date().addingTimeInterval(-30*24*60*60)...Date()
    @Published var selectedMicroplasticTypes: Set<MicroplasticType> = Set(MicroplasticType.allCases)
    
    init() {
        generateDummyData()
        applyFilters()
    }
    
    private func generateDummyData() {
        // GBU Campus detailed coordinates - more precise and focused
        let gbuCampusLocations = [
            // Main Academic Buildings
            (28.5091, 77.4502, "Central Administration Block", 45.0),
            (28.5093, 77.4505, "Main Library", 38.0),
            (28.5095, 77.4508, "Computer Science Department", 52.0),
            (28.5097, 77.4511, "Electronics Engineering Block", 48.0),
            (28.5099, 77.4514, "Mechanical Engineering Block", 55.0),
            (28.5101, 77.4517, "Civil Engineering Block", 42.0),
            (28.5103, 77.4520, "Electrical Engineering Block", 49.0),
            (28.5105, 77.4523, "Biotechnology Department", 35.0),
            
            // Student Areas
            (28.5088, 77.4505, "Student Center", 28.0),
            (28.5086, 77.4508, "Cafeteria Area", 65.0),
            (28.5084, 77.4511, "Student Hostel Block A", 58.0),
            (28.5082, 77.4514, "Student Hostel Block B", 62.0),
            (28.5080, 77.4517, "Student Hostel Block C", 55.0),
            (28.5078, 77.4520, "Student Hostel Block D", 48.0),
            
            // Sports and Recreation
            (28.5098, 77.4495, "Main Sports Complex", 25.0),
            (28.5096, 77.4498, "Basketball Court", 18.0),
            (28.5094, 77.4501, "Tennis Court", 22.0),
            (28.5092, 77.4504, "Cricket Ground", 15.0),
            (28.5090, 77.4507, "Swimming Pool Area", 12.0),
            (28.5088, 77.4510, "Gymnasium", 35.0),
            
            // Research Facilities
            (28.5108, 77.4498, "Research Lab Complex A", 68.0),
            (28.5110, 77.4501, "Research Lab Complex B", 72.0),
            (28.5112, 77.4504, "Chemistry Lab", 75.0),
            (28.5114, 77.4507, "Physics Lab", 58.0),
            (28.5116, 77.4510, "Biology Lab", 45.0),
            (28.5118, 77.4513, "Environmental Lab", 82.0),
            
            // Campus Infrastructure
            (28.5085, 77.4495, "Main Gate Entrance", 85.0),
            (28.5087, 77.4498, "Security Office", 78.0),
            (28.5089, 77.4501, "Parking Area A", 92.0),
            (28.5091, 77.4504, "Parking Area B", 88.0),
            (28.5093, 77.4507, "Parking Area C", 95.0),
            (28.5095, 77.4510, "Main Road Intersection", 98.0),
            
            // Green Areas and Water Bodies
            (28.5100, 77.4490, "Central Garden", 8.0),
            (28.5102, 77.4493, "Botanical Garden", 5.0),
            (28.5104, 77.4496, "Pond Area", 12.0),
            (28.5106, 77.4499, "Tree Plantation Zone", 3.0),
            (28.5108, 77.4502, "Meditation Garden", 2.0),
            (28.5110, 77.4505, "Herb Garden", 4.0),
            
            // Faculty and Staff Areas
            (28.5080, 77.4490, "Faculty Quarters A", 42.0),
            (28.5082, 77.4493, "Faculty Quarters B", 38.0),
            (28.5084, 77.4496, "Staff Canteen", 68.0),
            (28.5086, 77.4499, "Faculty Club", 35.0),
            (28.5088, 77.4502, "Guest House", 28.0),
            
            // High Traffic Areas
            (28.5095, 77.4500, "Main Bus Stop", 95.0),
            (28.5097, 77.4503, "Cycle Stand Area", 88.0),
            (28.5099, 77.4506, "ATM Area", 82.0),
            (28.5101, 77.4509, "Bank Branch", 75.0),
            (28.5103, 77.4512, "Post Office", 68.0),
            
            // Construction and Maintenance
            (28.5115, 77.4520, "Construction Site A", 98.0),
            (28.5117, 77.4523, "Construction Site B", 95.0),
            (28.5119, 77.4526, "Maintenance Workshop", 88.0),
            (28.5121, 77.4529, "Generator Room", 92.0),
            (28.5123, 77.4532, "Water Treatment Plant", 85.0),
            
            // Additional Campus Points
            (28.5083, 77.4503, "Campus Clinic", 25.0),
            (28.5085, 77.4506, "Book Store", 35.0),
            (28.5087, 77.4509, "Stationery Shop", 42.0),
            (28.5089, 77.4512, "Photocopy Center", 58.0),
            (28.5091, 77.4515, "Internet Cafe", 65.0),
            (28.5093, 77.4518, "Mobile Repair Shop", 72.0),
            (28.5095, 77.4521, "Snack Counter", 78.0),
            (28.5097, 77.4524, "Coffee Shop", 55.0),
            (28.5099, 77.4527, "Printing Center", 48.0),
            (28.5101, 77.4530, "Computer Lab", 38.0),
            
        // Specific GBU Campus Landmarks
        (28.422972, 77.525139, "GBU Swimming Pool", 15.0),
        (28.418611, 77.523222, "GBU Sarovar (Lake)", 8.0),
        (28.427278, 77.526389, "Valmiki Hostel", 12.0),
        (28.416111, 77.520833, "Admin Block", 18.0),
        (28.425000, 77.524000, "Central Library", 10.0),
        (28.420000, 77.522000, "Student Center", 14.0),
        (28.423000, 77.521000, "Cafeteria", 16.0),
        (28.419000, 77.524000, "Sports Complex", 13.0),
        (28.426000, 77.523000, "Faculty Quarters", 11.0),
        (28.421000, 77.520000, "Parking Area", 9.0)
        ]
        
        samples = gbuCampusLocations.enumerated().map { index, location in
            let (lat, lon, name, intensity) = location
            let daysAgo = Int.random(in: 0...30)
            let sampleDate = Date().addingTimeInterval(-Double(daysAgo * 24 * 60 * 60))
            
            return MicroplasticSample(
                latitude: lat,
                longitude: lon,
                intensity: intensity,
                microplasticType: MicroplasticType.random(),
                particleCount: Int.random(in: 50...800),
                sampleDate: sampleDate,
                locationName: name,
                collectedBy: ["Admin", "Researcher", "Field Agent"].randomElement() ?? "Admin"
            )
        }
    }
    
    func applyFilters() {
        filteredSamples = samples.filter { sample in
            let intensityMatch = selectedIntensityRange.contains(sample.intensity)
            let dateMatch = selectedDateRange.contains(sample.sampleDate)
            let typeMatch = selectedMicroplasticTypes.contains(sample.microplasticType)
            
            return intensityMatch && dateMatch && typeMatch
        }
    }
    
    func updateIntensityRange(_ range: ClosedRange<Double>) {
        selectedIntensityRange = range
        applyFilters()
    }
    
    func updateDateRange(_ range: ClosedRange<Date>) {
        selectedDateRange = range
        applyFilters()
    }
    
    func updateMicroplasticTypes(_ types: Set<MicroplasticType>) {
        selectedMicroplasticTypes = types
        applyFilters()
    }
}
