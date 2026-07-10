//
//  HomeView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import Foundation
import SwiftData

struct HomeView: View {
    @Query private var clothingItems: [ClothingItem]
    @Query private var outfits: [Outfit]
    @Environment(\.modelContext) private var context
    
    var calendar = Calendar.current
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("weekOfMonthLastOpened")
        private var weekOfMonthLastOpened = 0
    
    var body: some View {
        VStack() {
            
            Button {
                Task {
                    let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
                    if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                        let generatedOutfit = await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, previousOutfits: outfits)
                        
                        context.insert(generatedOutfit)
                        
                        print(generatedOutfit)
                        print(outfits)
                    } else {
                        print("Outfit could not be generated")
                    }

                }
            } label: {
                Text("Generate Outfit")
            }

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    
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

#Preview {
    MainTabView()
}
