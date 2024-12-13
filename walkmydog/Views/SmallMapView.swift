//
//  SmallMapView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/11.
//

import SwiftUI
import MapKit

struct SmallMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let isTracking: Bool
    let onTap: () -> Void
    let userLocation: CLLocationCoordinate2D?
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            if userLocation != nil {
                UserAnnotation()
            }
        }
        .frame(height: 300)
        .onTapGesture {
            if !isTracking {
                onTap()
            }
        }
    }
}
