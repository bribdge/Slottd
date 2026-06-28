//
//  NewClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 27/06/2026.
//

import SwiftUI

struct NewClothingItemView: View {
    var appData: AppData
    
    @State private var clothingItemName = ""
    @State private var clothingItemStyle: ClothingStyle?
    @State private var clothingItemColor: ClothingColor?
    @State private var clothingItemType: ClothingType?
    var body: some View {
        VStack {
            List {
                Section("Clothing Item Name") {
                    TextField("Clothing Name", text: $clothingItemName)
                }
            }
        }
    }
}

#Preview {
    NewClothingItemView(appData: AppData(clothingItems: [], currentWeekOutfitPlan: nil))
}
