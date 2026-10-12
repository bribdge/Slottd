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
    
    var calendarManager: CalendarManager
    
    @State private var isGenerating = false
    
    @State private var calendarAccessDenied = false
    @AppStorage("unableToGenerateOutfit") var unableToGenerateOutfit: Bool = false
    
    @State private var showingInfoSheet = false
    @State private var showingAIInfoSheet = false
    
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
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color(Color.background)
                        .ignoresSafeArea()
                    VStack() {
                        EventPickerModuleView(calendarManager: calendarManager, selectedEventIdentifier: $selectedEventIdentifier)
                        
                        if isGenerating || unableToGenerateOutfit {
                            PlaceholderOutfitModuleView(isGenerating: $isGenerating, unableToGenerateOutfit: $unableToGenerateOutfit)
                        } else {
                            SelectedOutfitModuleView(isGenerating: $isGenerating, calendarManager: calendarManager, selectedEventIdentifier: $selectedEventIdentifier)
                        }
                        
                    }
                    .navigationTitle("Today's Outfits")
                    
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            showingInfoSheet.toggle()
                        } label: {
                            Image(systemName: "info")
                        }
                    }
                }
                .sheet(isPresented: $showingInfoSheet) {
                    BetaInfoSheetView()
                        .presentationDetents([.fraction(0.45), .fraction(0.6)])
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

        withAnimation {
            isGenerating = true
        }

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
                    occasionTitle: event.title.trimmingCharacters(in: .whitespacesAndNewlines),
                    occasionIdentifier: event.eventIdentifier
                ))
            }

            context.insert(DailyOutfitList(dailyOutfit: dailyOutfit, eventOutfits: eventOutfits))
            try? context.save()

            dateLastOpened = Date()
            withAnimation {
                isGenerating = false
            }
        }
    }
}
    

#Preview {
    MainTabView()
}
