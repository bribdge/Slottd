//
//  ContentView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

@Model
class AppData {
    var clothingItems: [ClothingItem] = []
    
    var currentWeekOutfitPlan: [Outfit] = []
    
    init(clothingItems: [ClothingItem], currentWeekOutfitPlan: [Outfit]) {
        self.clothingItems = clothingItems
        self.currentWeekOutfitPlan = currentWeekOutfitPlan
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var saves: [AppData]

    var body: some View {
        if let appData = saves.first { // the if let checks if saves.first ACTUALLY exists. if so, it just opens home view and passes in app data
            HomeView(appData: appData)
        } else { //if theres no save
            ProgressView() // literally just a spinning circle to show the app is doing something
                .task {
                    let newSave = AppData(clothingItems: [], currentWeekOutfitPlan: []) // creating a new save
                    context.insert(newSave) // adding the new save
                }
        }
    }
}

#Preview {
    HomeView(appData: AppData(clothingItems: [], currentWeekOutfitPlan: []))
}
