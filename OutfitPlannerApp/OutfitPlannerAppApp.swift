//
//  OutfitPlannerAppApp.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import SwiftData

@Model
class AppData {
    init() {
        
    }
}

@main
struct OutfitPlannerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ClothingItem.self, Outfit.self, StarredOutfit.self, DailyOutfitList.self])
    }
}
