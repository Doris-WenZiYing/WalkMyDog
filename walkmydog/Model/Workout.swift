//
//  Workout.swift
//  walkmydog
//
//  Created by App_team on 2024/12/11.
//

import SwiftData
import CoreLocation

@Model
class Workout {
    @Attribute(.unique) var id: UUID
    var date: Date
    var distance: Double
    var duration: Double
    @Relationship(deleteRule: .cascade) var routePoints: [RoutePoint]
    
    init(id: UUID, date: Date, distance: Double, duration: Double, routePoints: [RoutePoint]) {
        self.id = id
        self.date = date
        self.distance = distance
        self.duration = duration
        self.routePoints = routePoints
    }
}

@Model
class RoutePoint {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Workout {
    var formattedDistance: String {
        let km = distance / 1000.0
        return String(format: "%.2f km", km)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        if hours > 0 {
            return String(format: "%dh %dm %ds", hours, minutes, seconds)
        } else {
            return String(format: "%dm %ds", minutes, seconds)
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        routePoints.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }
}
