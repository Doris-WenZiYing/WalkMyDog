//
//  MapTrackingView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/10.
//

import SwiftUI
import MapKit
import SwiftData

struct MapTrackingView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: MapTrackingViewModel
    
    @State private var showSettingsAlert: Bool = false
    @State private var showFullScreen = false
    
    var body: some View {
        VStack {
            SmallMapView(cameraPosition: $viewModel.cameraPosition,
                         isTracking: viewModel.isTracking,
                         onTap: {
                // only show fullscreen if not tracking and we have a route
                if !viewModel.isTracking && !viewModel.trackedLocations.isEmpty {
                    showFullScreen = true
                }
            }, userLocation: locationManager.userLocation?.coordinate)
            
            HStack {
                Button(viewModel.isTracking ? "Pause" : "Start", role: .none) {
                    if viewModel.isTracking {
                        viewModel.pauseTracking()
                    } else {
                        if !locationManager.isAuthorized {
                            showSettingsAlert = true
                        } else {
                            viewModel.startTracking()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Stop", role: .destructive) {
                    viewModel.stopTracking(modelContext: modelContext)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Location Permission Needed",
               isPresented: $showSettingsAlert) {
            Button("Go to Settings") {
                viewModel.openLocationSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow location access in Settings to enable route tracking.")
        }
        .onAppear {
            if !locationManager.isAuthorized {
                showSettingsAlert = true
            }
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenMapView(cameraPosition: $viewModel.cameraPosition,
                              trackedLocations: viewModel.trackedLocations,
                              userLocation: locationManager.userLocation?.coordinate,
                              onDismiss: {
                showFullScreen = false
            })
        }
    }
}

#Preview {
    MapTrackingView(viewModel: MapTrackingViewModel(locationManager: LocationManager()))
        .environmentObject(LocationManager())
        .modelContainer(for: [Workout.self, RoutePoint.self])
}
