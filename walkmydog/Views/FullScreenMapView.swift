//
//  FullScreenMapView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/11.
//

import SwiftUI
import MapKit

struct FullScreenMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let trackedLocations: [CLLocationCoordinate2D]
    let userLocation: CLLocationCoordinate2D?
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $cameraPosition, interactionModes: .all) {
                if userLocation != nil {
                    UserAnnotation()
                }
                if !trackedLocations.isEmpty {
                    MapPolyline(coordinates: trackedLocations)
                        .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
            }
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.white.opacity(0.8).clipShape(Circle()))
            }
            .padding()
        }
    }
}
