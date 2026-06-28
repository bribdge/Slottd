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
            Button {
                appData.clothingItems.append(contentsOf: [
                    ClothingItem(name: "White Linen Shirt", style: .minimalist, colour: .white, type: .top),
                    ClothingItem(name: "Olive Cargo Pants", style: .streetwear, colour: .olive, type: .bottom),
                    ClothingItem(name: "Neon Yellow Slides", style: .vibrant, colour: .yellow, type: .footwear)])
            } label: {
                Text("test add items")
            }
            
            Button {
                appData.currentWeekOutfitPlan = generateWeekOutfitPlan(clothingItems: appData.clothingItems)
            } label: {
                Text("test rebuild")
            }
            
            Button {
                newClothingItemSheetIsPresented.toggle()
            } label: {
                Text("new clothing item")
            }


            
            let weekOutfitPlan = appData.currentWeekOutfitPlan

            Text((weekOutfitPlan?.mondayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.mondayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.mondayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.tuesdayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.tuesdayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.tuesdayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.wednesdayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.wednesdayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.wednesdayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.thursdayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.thursdayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.thursdayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.fridayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.fridayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.fridayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.saturdayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.saturdayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.saturdayOutfit?.footwear.name ?? "nil"))
            Spacer()

            Text((weekOutfitPlan?.sundayOutfit?.top.name ?? "nil"))
            Text((weekOutfitPlan?.sundayOutfit?.bottom.name ?? "nil"))
            Text((weekOutfitPlan?.sundayOutfit?.footwear.name ?? "nil"))

            
        }
        .frame(height: 600)
        .sheet(isPresented: $newClothingItemSheetIsPresented) {
            NewClothingItemView(appData: appData)
        }
        
        .onChange(of: scenePhase) { _, newPhase in
            print("onChange opened - Scene phase changed to:", newPhase)
            
            if newPhase == .active {
                if (calendar.component(.weekOfMonth, from: Date()) != weekOfMonthLastOpened) {
                    print("Week of month changed.")
                    appData.currentWeekOutfitPlan = generateWeekOutfitPlan(clothingItems: appData.clothingItems)
                }

                weekOfMonthLastOpened = calendar.component(.weekOfMonth, from: Date())
                print("New week of month: \(weekOfMonthLastOpened)")
            }
        }
    }
}

#Preview {
    HomeView(appData: AppData(clothingItems: [
        // --- Your Original Items ---
//        ClothingItem(name: "Black Hoodie", style: .casual, colour: .black, type: .outerwear),
//        ClothingItem(name: "White Linen Shirt", style: .minimalist, colour: .white, type: .top),
//        ClothingItem(name: "Olive Cargo Pants", style: .streetwear, colour: .olive, type: .bottom),
//        ClothingItem(name: "Floral Summer Dress", style: .romantic, colour: .pastelPink, type: .onePiece),
//        ClothingItem(name: "Maroon Plaid Skirt", style: .preppy, colour: .maroon, type: .skirt),
//        ClothingItem(name: "Neon Yellow Beanie", style: .vibrant, colour: .yellow, type: .accessory),
//        ClothingItem(name: "Neon Yellow Slides", style: .vibrant, colour: .yellow, type: .footwear),
//
//        // --- Formal / Smart Archetypes (Mapped to Chic / Minimalist) ---
//        ClothingItem(name: "Navy Tailored Blazer", style: .chic, colour: .navyBlue, type: .outerwear),
//        ClothingItem(name: "Charcoal Dress Pants", style: .minimalist, colour: .charcoal, type: .bottom),
//        ClothingItem(name: "Black Leather Oxfords", style: .chic, colour: .black, type: .footwear),
//        ClothingItem(name: "Cream Trench Coat", style: .minimalist, colour: .cream, type: .outerwear),
//
//        // --- Denim & Basics (Universal Matches) ---
//        ClothingItem(name: "Classic Blue Jeans", style: .casual, colour: .lightBlue, type: .bottom),
//        ClothingItem(name: "Grey T-Shirt", style: .minimalist, colour: .lightGray, type: .top),
//        ClothingItem(name: "White Leather Sneakers", style: .casual, colour: .white, type: .footwear),
//
//        // --- Alternative / Edgy (Subculture Checks) ---
//        ClothingItem(name: "Oversized Graphic Tee", style: .streetwear, colour: .black, type: .top),
//        ClothingItem(name: "Black Moto Jacket", style: .edgy, colour: .black, type: .outerwear),
//        ClothingItem(name: "Combat Boots", style: .edgy, colour: .black, type: .footwear),
//
//        // --- Saturated / High-Contrast Neutrals (Color Clash Tests) ---
//        ClothingItem(name: "Royal Blue Sweater", style: .vibrant, colour: .royalBlue, type: .top),
//        ClothingItem(name: "Tan Chinos", style: .chic, colour: .tan, type: .bottom),
//        ClothingItem(name: "Rust Velvet Loafers", style: .preppy, colour: .rust, type: .footwear),
//
//        // --- Extras to round out the logic ---
//        ClothingItem(name: "Silver Chain Necklace", style: .minimalist, colour: .lightGray, type: .accessory),
//        ClothingItem(name: "Brown Leather Belt", style: .preppy, colour: .brown, type: .accessory),
//        
//        // --- Bohemian & Romantic (Earthy, Soft Textures) ---
//        ClothingItem(name: "Olive Corduroy Flares", style: .bohemian, colour: .olive, type: .bottom),
//        ClothingItem(name: "Cream Crochet Top", style: .bohemian, colour: .cream, type: .top),
//        ClothingItem(name: "Suede Ankle Boots", style: .bohemian, colour: .tan, type: .footwear),
//        ClothingItem(name: "Lavender Silk Scarf", style: .romantic, colour: .lavender, type: .accessory),
//
//        // --- Retro & Vintage (Bold Palettes from the Past) ---
//        ClothingItem(name: "Mustard Knit Vest", style: .retro, colour: .mustard, type: .top),
//        ClothingItem(name: "Rust Corduroy Jacket", style: .vintage, colour: .rust, type: .outerwear),
//        ClothingItem(name: "Peach Button-Up Shirt", style: .vintage, colour: .peach, type: .top),
//        ClothingItem(name: "Espresso Leather Loafers", style: .vintage, colour: .espresso, type: .footwear),
//
//        // --- Cyberpunk & Avant-Garde (Techwear, High-Contrast Monochromes) ---
//        ClothingItem(name: "Asymmetrical Cargo Vest", style: .cyberpunk, colour: .black, type: .outerwear),
//        ClothingItem(name: "Strapped Tech Pants", style: .cyberpunk, colour: .charcoal, type: .bottom),
//        ClothingItem(name: "Neon Orange Windbreaker", style: .cyberpunk, colour: .orange, type: .outerwear),
//        ClothingItem(name: "Sculptural Chunky Sneakers", style: .avantGarde, colour: .white, type: .footwear),
//
//        // --- Glam & Eclectic (Loud Patterns, Saturated Accents) ---
//        ClothingItem(name: "Royal Blue Satin Blazer", style: .glam, colour: .royalBlue, type: .outerwear),
//        ClothingItem(name: "Plum Pleated Trousers", style: .eclectic, colour: .plum, type: .bottom),
//        ClothingItem(name: "Emerald Green Heels", style: .glam, colour: .emeraldGreen, type: .footwear),
//        ClothingItem(name: "Gold Chain Belt", style: .glam, colour: .yellow, type: .accessory),
//
//        // --- Sporty & Casual Basics (Expanding the Daily Pool) ---
//        ClothingItem(name: "Mint Green Hoodie", style: .sporty, colour: .mintGreen, type: .outerwear),
//        ClothingItem(name: "Navy Blue Track Shorts", style: .sporty, colour: .navyBlue, type: .bottom),
//        ClothingItem(name: "Light Blue Denim Shorts", style: .casual, colour: .lightBlue, type: .bottom),
//        ClothingItem(name: "Pastel Pink Cap", style: .sporty, colour: .pastelPink, type: .accessory),
//
//        // --- Minimalist / Chic Expansion ---
//        ClothingItem(name: "Silk Black Slip Dress", style: .minimalist, colour: .black, type: .onePiece),
//        ClothingItem(name: "Off-White Tailored Waistcoat", style: .chic, colour: .cream, type: .top),
//        ClothingItem(name: "Black Leather Mules", style: .minimalist, colour: .black, type: .footwear),
//        ClothingItem(name: "Charcoal Wool Coat", style: .chic, colour: .charcoal, type: .outerwear),
//
//        // --- Grunge & Streetwear Realignment ---
//        ClothingItem(name: "Distressed Denim Jacket", style: .grunge, colour: .lightBlue, type: .outerwear),
//        ClothingItem(name: "Baggy Grey Carpenter Jeans", style: .grunge, colour: .lightGray, type: .bottom),
//        ClothingItem(name: "Charcoal Oversized Zip-Up", style: .streetwear, colour: .charcoal, type: .outerwear),
//        ClothingItem(name: "High-Top Skate Shoes", style: .streetwear, colour: .white, type: .footwear),
//
//        // --- Retro, Vintage & Preppy Mix ---
//        ClothingItem(name: "Brown Tweed Blazer", style: .preppy, colour: .brown, type: .outerwear),
//        ClothingItem(name: "Beige Turtleneck Sweater", style: .retro, colour: .cream, type: .top),
//        ClothingItem(name: "Houndstooth Trousers", style: .vintage, colour: .charcoal, type: .bottom),
//        ClothingItem(name: "Oxblood Leather Satchel", style: .preppy, colour: .maroon, type: .accessory),
//
//        // --- Sporty / Casual Fillers ---
//        ClothingItem(name: "Espresso Cropped Hoodie", style: .sporty, colour: .espresso, type: .outerwear),
//        ClothingItem(name: "Sage Green Leggings", style: .sporty, colour: .mintGreen, type: .bottom),
//        ClothingItem(name: "Heather Grey Sweatpants", style: .casual, colour: .lightGray, type: .bottom),
//        
//        // --- Avant-Garde & Eclectic Extras ---
//        ClothingItem(name: "Asymmetrical Red Blouse", style: .avantGarde, colour: .red, type: .top),
//        ClothingItem(name: "Metallic Orange Sunglasses", style: .eclectic, colour: .orange, type: .accessory),
//        ClothingItem(name: "Purple Velvet Jumpsuit", style: .eclectic, colour: .purple, type: .onePiece)
    ], currentWeekOutfitPlan: nil))
}
