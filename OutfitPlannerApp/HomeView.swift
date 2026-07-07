//
//  HomeView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import Foundation

struct HomeView: View {
    var appData: AppData
    
    var calendar = Calendar.current
    
    @State private var newClothingItemSheetIsPresented = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("weekOfMonthLastOpened")
        private var weekOfMonthLastOpened = 0
    
    var body: some View {
        VStack {
            ForEach(appData.currentOutfitPlan) { outfit in
                Text(outfit.top.name)
                Text(outfit.bottom.name)
                Text(outfit.footwear.name)
            }
        }
        .frame(height: 600)
        .sheet(isPresented: $newClothingItemSheetIsPresented) {
            NewClothingItemView(appData: appData)
        }
        
//        .onChange(of: scenePhase) { _, newPhase in
//            print("onChange opened - Scene phase changed to:", newPhase)
//            
//            if newPhase == .active {
//                if (calendar.component(.weekOfMonth, from: Date()) != weekOfMonthLastOpened) {
//                    print("Week of month changed.")
//                    appData.currentWeekOutfitPlan = generateWeekOutfitPlan(clothingItems: appData.clothingItems).outfitPlan
//                }
//
//                weekOfMonthLastOpened = calendar.component(.weekOfMonth, from: Date())
//                print("New week of month: \(weekOfMonthLastOpened)")
//            }
//        }
    }
}

#Preview {
    HomeView(appData: AppData(clothingItems: [
            ClothingItem(name: "Black Hoodie", style: .casual, colour: .black, type: .outerwear, image: nil),
            ClothingItem(name: "White Linen Shirt", style: .minimalist, colour: .white, type: .top, image: nil),
            ClothingItem(name: "Olive Cargo Pants", style: .streetwear, colour: .olive, type: .bottom, image: nil),
            ClothingItem(name: "Maroon Plaid Skirt", style: .preppy, colour: .maroon, type: .skirt, image: nil),
            ClothingItem(name: "Neon Yellow Beanie", style: .vibrant, colour: .yellow, type: .accessory, image: nil),
            ClothingItem(name: "Neon Yellow Slides", style: .vibrant, colour: .yellow, type: .footwear, image: nil),

            // --- Formal / Smart Archetypes (Mapped to Chic / Minimalist) ---
            ClothingItem(name: "Navy Tailored Blazer", style: .chic, colour: .navyBlue, type: .outerwear, image: nil),
            ClothingItem(name: "Charcoal Dress Pants", style: .minimalist, colour: .charcoal, type: .bottom, image: nil),
            ClothingItem(name: "Black Leather Oxfords", style: .chic, colour: .black, type: .footwear, image: nil),
            ClothingItem(name: "Cream Trench Coat", style: .minimalist, colour: .cream, type: .outerwear, image: nil),

            // --- Denim & Basics (Universal Matches) ---
            ClothingItem(name: "Classic Blue Jeans", style: .casual, colour: .lightBlue, type: .bottom, image: nil),
            ClothingItem(name: "Grey T-Shirt", style: .minimalist, colour: .lightGray, type: .top, image: nil),
            ClothingItem(name: "White Leather Sneakers", style: .casual, colour: .white, type: .footwear, image: nil),

            // --- Alternative / Edgy (Subculture Checks) ---
            ClothingItem(name: "Oversized Graphic Tee", style: .streetwear, colour: .black, type: .top, image: nil),
            ClothingItem(name: "Black Moto Jacket", style: .edgy, colour: .black, type: .outerwear, image: nil),
            ClothingItem(name: "Combat Boots", style: .edgy, colour: .black, type: .footwear, image: nil),

            // --- Saturated / High-Contrast Neutrals (Color Clash Tests) ---
            ClothingItem(name: "Royal Blue Sweater", style: .vibrant, colour: .royalBlue, type: .top, image: nil),
            ClothingItem(name: "Tan Chinos", style: .chic, colour: .tan, type: .bottom, image: nil),
            ClothingItem(name: "Rust Velvet Loafers", style: .preppy, colour: .rust, type: .footwear, image: nil),

            // --- Extras to round out the logic ---
            ClothingItem(name: "Silver Chain Necklace", style: .minimalist, colour: .lightGray, type: .accessory, image: nil),
            ClothingItem(name: "Brown Leather Belt", style: .preppy, colour: .brown, type: .accessory, image: nil),
            
            // --- Bohemian & Romantic (Earthy, Soft Textures) ---
            ClothingItem(name: "Olive Corduroy Flares", style: .bohemian, colour: .olive, type: .bottom, image: nil),
            ClothingItem(name: "Cream Crochet Top", style: .bohemian, colour: .cream, type: .top, image: nil),
            ClothingItem(name: "Suede Ankle Boots", style: .bohemian, colour: .tan, type: .footwear, image: nil)], currentWeekOutfitPlan: []))
}
