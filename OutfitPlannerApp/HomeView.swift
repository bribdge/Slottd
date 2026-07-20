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
    @Query private var dailyOutfitList: [DailyOutfitList]
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    var calendar = Calendar.current
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("dateLastOpened")
        private var dateLastOpened = Date.distantPast
    
    @State private var calendarManager: CalendarManager = CalendarManager()
    
    @State private var isGenerating = false
    @State private var calendarAccessDenied = false
    @State private var unableToGenerateOutfit: Bool = false
    
    @State private var selectedEventIdentifier: String? = nil
    var selectedOutfit: Outfit? {
        if let selectedOutfit = dailyOutfitList.first?.eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier}) {
            return selectedOutfit
        } else {
            if let selectedOutfit = dailyOutfitList.first?.dailyOutfit {
                return selectedOutfit
            }
        }
        return nil
    }
    
    var backgroundColor: Color {
        if colorScheme == .light {
            return Color(red: 0.98, green: 0.97, blue: 0.93)
        } else {
            return Color(red: 0.07, green: 0.05, blue: 0.04)
        }
    }

    var buttonColor: Color {
        if colorScheme == .light {
            return Color(red: 0.65, green: 0.15, blue: 0.15) // Deep elegant crimson
        } else {
            return Color(red: 0.91, green: 0.29, blue: 0.29) // Vivid crimson for contrast
        }
    }


    var body: some View {
            NavigationStack {
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
                    VStack() {
                        EventPickerModuleView(calendarManager: calendarManager, selectedEventIdentifier: $selectedEventIdentifier)
                        if isGenerating || unableToGenerateOutfit {
                            PlaceholderOutfitModuleView(calendarManager: calendarManager, selectedEventIdentifier: $selectedEventIdentifier, isGenerating: $isGenerating, unableToGenerateOutfit: $unableToGenerateOutfit)
                        } else {
                            SelectedOutfitModuleView(isGenerating: $isGenerating, calendarManager: calendarManager, selectedEventIdentifier: $selectedEventIdentifier)
                        }
                        
                    }
                    .navigationTitle("Today's Outfits")
                    
                }
        }
        .onChange(of: clothingItems.count) {
            let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
            if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                unableToGenerateOutfit = false
            } else {
                unableToGenerateOutfit = true
            }
        }
        
        .onChange(of: unableToGenerateOutfit) {
            if !unableToGenerateOutfit {
                regenerateOutfits()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && !Calendar.current.isDateInToday(dateLastOpened) {
                regenerateOutfits()
            }
        }
        .onAppear {
            Task {
                if calendarManager.authorizationStatus == .notDetermined {
                    await calendarManager.requestAccess()
                }
                calendarManager.fetchEvents()
                if !Calendar.current.isDateInToday(dateLastOpened) {
                    regenerateOutfits()
                }
            }
        }

    }
    
    private func regenerateOutfits() {
        let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
        guard !separatedClothingItems.tops.isEmpty,
              !separatedClothingItems.bottoms.isEmpty,
              !separatedClothingItems.footwear.isEmpty else {
            unableToGenerateOutfit = true
            return
        }
        unableToGenerateOutfit = false

        withAnimation { isGenerating = true }

        for outfitList in dailyOutfitList {
            context.delete(outfitList)
        }
        try? context.save()

        Task {
            calendarManager.fetchEvents()

            let dailyOutfit = await generateDailyOutfit(
                tops: separatedClothingItems.tops,
                bottoms: separatedClothingItems.bottoms,
                footwear: separatedClothingItems.footwear,
                accessories: separatedClothingItems.accessories,
                outerwear: separatedClothingItems.outerwear,
                occasionTitle: "",
                occasionIdentifier: nil
            )

            var eventOutfits: [Outfit] = []
            for event in calendarManager.events {
                eventOutfits.append(await generateDailyOutfit(
                    tops: separatedClothingItems.tops,
                    bottoms: separatedClothingItems.bottoms,
                    footwear: separatedClothingItems.footwear,
                    accessories: separatedClothingItems.accessories,
                    outerwear: separatedClothingItems.outerwear,
                    occasionTitle: event.title.trimmingCharacters(in: .whitespacesAndNewlines),
                    occasionIdentifier: event.eventIdentifier
                ))
            }

            context.insert(DailyOutfitList(dailyOutfit: dailyOutfit, eventOutfits: eventOutfits))
            try? context.save()

            dateLastOpened = Date()
            withAnimation { isGenerating = false }
        }
    }
}
    

#Preview {
    MainTabView()
}
