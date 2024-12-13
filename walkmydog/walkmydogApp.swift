//
//  walkmydogApp.swift
//  walkmydog
//
//  Created by App_team on 2024/12/10.
//

import SwiftUI
import SwiftData

@main
struct walkmydogApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = MapTrackingViewModel(locationManager: LocationManager())
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environmentObject(locationManager)
                .environmentObject(viewModel)
                .modelContainer(for: [Workout.self, RoutePoint.self])
        }
    }
}
