//
//  NewClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 27/06/2026.
//

import SwiftUI
import PhotosUI

struct NewClothingItemView: View {
    var appData: AppData
    
    @State private var clothingItemName = ""
    @State private var clothingItemType: ClothingType = .top
    @State private var clothingItemStyle: ClothingStyle = .minimalist
    @State private var clothingItemColor: ClothingColor = .lightBlue
    var body: some View {
        VStack {
            List {
                Section("Clothing Item Name") {
                    TextField("Name", text: $clothingItemName)
                }
                Section("Clothing Item Info") {
                    Picker("Type", selection: $clothingItemType) {
                        ForEach(ClothingType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    Picker("Style", selection: $clothingItemStyle) {
                        ForEach(ClothingStyle.allCases) { style in
                            Text(style.rawValue.capitalized)
                        }
                    }
                    Picker("Color", selection: $clothingItemColor) {
                        ForEach(ClothingColor.allCases) { color in
                            Text(color.rawValue.capitalized)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewClothingItemView(appData: AppData(clothingItems: [], currentWeekOutfitPlan: []))
}
