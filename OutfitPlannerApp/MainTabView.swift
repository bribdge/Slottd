//
//  MainTabView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 08/07/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var tabColor: Color {
        if colorScheme == .light {
            return Color(red: 0.65, green: 0.15, blue: 0.15) // Deep elegant crimson
        } else {
            return Color(red: 0.91, green: 0.29, blue: 0.29) // Vivid crimson for contrast
        }
    }
    
    var body: some View {
        TabView {
            HomeView().tabItem() {
                Label("Overview", systemImage: "house")
            }
            ClothingItemsView().tabItem() {
                Label("Clothing", systemImage: "hanger")
            }
            FavoriteOutfitsListView().tabItem() {
                Label("Favorites", systemImage: "star")
            }
        }
        .tint(tabColor)
    }
}

#Preview {
    MainTabView()
}
