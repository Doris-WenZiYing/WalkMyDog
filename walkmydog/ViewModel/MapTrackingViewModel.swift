//
//  MapTrackingViewModel.swift
//  walkmydog
//
//  Created by App_team on 2024/12/11.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine
import SwiftData

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

@MainActor
class MapTrackingViewModel: ObservableObject {
    @Published var isTracking: Bool = false
    @Published var trackedLocations: [CLLocationCoordinate2D] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    private var startTime: Date? = nil
    private var totalDistance: Double = 0.0

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        observeUserLocation()
    }

    private func observeUserLocation() {
        locationManager.$userLocation
            .compactMap { $0 }
            .filter { [weak self] location in
                guard let lastLocation = self?.trackedLocations.last else { return true }
                let distance = location.distance(from: CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude))
                return distance > 3
            }
            .sink { [weak self] location in
                guard let self = self else { return }
                self.updateCameraPosition(to: location.coordinate)
                if self.isTracking {
                    self.calculateDistance(location.coordinate)
                }
            }
            .store(in: &cancellables)
    }
    
    func startTracking() {
        guard locationManager.isAuthorized else { return }
        trackedLocations.removeAll()
        isTracking = true
        startTime = Date()
        locationManager.startTrackingLocation()
    }
    
    func stopTracking(modelContext: ModelContext) {
        isTracking = false
        locationManager.stopTrackingLocation()
        
        guard let startTime = startTime else { return }
        let endTime = Date()
        
        let duration = endTime.timeIntervalSince(startTime)
        let distance = totalDistance
        
        let routePoints = trackedLocations.map { RoutePoint(latitude: $0.latitude, longitude: $0.longitude) }
        let workout = Workout(id: UUID(), date: endTime, distance: distance, duration: duration, routePoints: routePoints)
        
        modelContext.insert(workout)
        do {
            try modelContext.save()
        } catch {
            print("Error saving workout: \(error)")
        }
        
        self.startTime = nil
        self.totalDistance = 0.0
    }
    
    func pauseTracking() {
        isTracking = false
    }
    
    func updateCameraPosition(to coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        )
        cameraPosition = .region(region)
    }
    
    func openLocationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func calculateDistance(_ location: CLLocationCoordinate2D) {
        if let lastLocation = trackedLocations.last {
            let start = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
            let end = CLLocation(latitude: location.latitude, longitude: location.longitude)
            totalDistance += end.distance(from: start)
        }
        trackedLocations.append(location)
    }
}

extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
