//
//  MainTabView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 08/07/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem() {
                Label("Overview", systemImage: "house")
            }
            ClothingItemsView().tabItem() {
                Label("Clothing", systemImage: "hanger")
            }
        }
    }
}

#Preview {
    MainTabView()
}
