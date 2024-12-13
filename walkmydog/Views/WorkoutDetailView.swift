//
//  WorkoutDetailView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/11.
//

import SwiftUI
import MapKit

struct WorkoutDetailView: View {
    let workout: Workout
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition, interactionModes: .zoom) {
//                if let firstCoord = workout.coordinates.first {
//                    MapMarker(coordinate: firstCoord) {
//                        Image(systemName: "figure.walk.circle.fill")
//                            .resizable()
//                            .frame(width: 32, height: 32)
//                            .foregroundColor(.blue)
//                    }
//                }
                if !workout.coordinates.isEmpty {
                    MapPolyline(coordinates: workout.coordinates)
                        .stroke(.red, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
            }
            .frame(height: 300)
            .onAppear {
                if !workout.coordinates.isEmpty {
                    let region = MKCoordinateRegion(
                        center: workout.coordinates[workout.coordinates.count / 2],
                        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                    )
                    cameraPosition = .region(region)
                }
            }
            
            Text(workout.formattedDate)
                .font(.title2)
                .padding(.top)
            
            HStack {
                Text("Distance: \(workout.formattedDistance)")
                Spacer()
                Text("Duration: \(workout.formattedDuration)")
            }
            .padding()
            
            Spacer()
        }
        .presentationDetents([.medium, .large])
        .navigationTitle("Workout Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
