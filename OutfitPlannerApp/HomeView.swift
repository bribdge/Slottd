//
//  HomeView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import Foundation
import SwiftData
import EventKit

struct HomeView: View {
    @Query private var clothingItems: [ClothingItem]
    @Query private var outfits: [Outfit]
    @Environment(\.modelContext) private var context
    
    var calendar = Calendar.current
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("dateLastOpened")
        private var dateLastOpened = Date.distantPast
    
    @State private var calendarManager: CalendarManager = CalendarManager()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack() {
                    
                    Button {
                        Task {
                            let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
                            if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                                let generatedOutfit = await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, previousOutfits: outfits)
                                
                                context.insert(generatedOutfit)
                                print(generatedOutfit.outfitRationale)

                                for outfit in outfits {
                                    print(outfit.description)
                                }
                            } else {
                                print("Outfit could not be generated")
                            }
                            
                        }
                    } label: {
                        Text("Generate Outfit")
                    }
                    .padding()
                        //                Button {
                        //                    Task {
                        //                        for outfit in outfits {
                        //                            context.delete(outfit)
                        //                        }
                        //                        
                        //                        try context.save()
                        //                        
                        //                        print(outfits)
                        //                    }
                        //                } label: {
                        //                    Text("Remove All Outfits")
                        //                }
                        //                .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Today's Outfits")
                
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            print("scenePhase: \(newPhase)")
            Task {
                if calendarManager.authorizationStatus == .notDetermined {
                    await calendarManager.requestAccess()
                }
            }
            calendarManager.fetchEvents()
            for event in calendarManager.events {
                print(event.title ?? "")
            }
            if newPhase == .active {
                if !Calendar.current.isDateInToday(dateLastOpened) {
                    print("\nDay has changed\n")
                    while outfits.count >= 6 { // while loop to remove more than one if more than one somehow got added
                        let outfitToRemove = outfits[5]
                        context.delete(outfitToRemove)
                    }
                }

                dateLastOpened = Date()
            }
        }
    }
}

#Preview {
    MainTabView()
}
