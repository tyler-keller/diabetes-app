//
//  ContentView.swift
//  diabetes-app
//
//  Created by Tyler Keller on 7/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            LogView()
                .tabItem {
                    Label("Log", systemImage: "square.and.pencil")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


#Preview {
    ContentView()
}
