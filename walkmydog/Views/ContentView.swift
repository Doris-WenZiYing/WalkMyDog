//
//  ContentView.swift
//  walkmydog
//
//  Created by App_team on 2024/12/10.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel: MapTrackingViewModel
    
    var body: some View {
        TabView {
            MapTrackingView(viewModel: viewModel)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    ContentView(viewModel: MapTrackingViewModel(locationManager: LocationManager()))
        .environmentObject(LocationManager())
}
