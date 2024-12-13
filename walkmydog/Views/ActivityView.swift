//
//  ActivityView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/10.
//

import SwiftUI
import SwiftData
import MapKit

struct ActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    Button {
                        selectedWorkout = workout
                    } label: {
                        HStack {
                            Text(workout.formattedDate)
                                .font(.headline)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(workout.formattedDistance)
                                Text(workout.formattedDuration)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Activities")
            .sheet(item: $selectedWorkout) { workout in
                WorkoutDetailView(workout: workout)
            }
        }
    }
    
    func deleteWorkouts(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(workouts[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("Error deleting workout: \(error)")
        }
    }
}

#Preview {
    ActivityView()
}
