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
    @State var calendarManager: CalendarManager = CalendarManager()
    
    var body: some View {
        TabView {
            HomeView(calendarManager: calendarManager).tabItem() {
                Label("Overview", systemImage: "house")
            }
            ClothingItemsView().tabItem() {
                Label("Clothing", systemImage: "hanger")
            }
        }
        .tint(Color.button)
    }
}

#Preview {
    MainTabView()
}
