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
    
    var calendar = Calendar.current
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("dateLastOpened")
        private var dateLastOpened = Date.distantPast
    
    @State private var calendarManager: CalendarManager = CalendarManager()
    
    @State private var isGenerating = false
    @State private var calendarAccessDenied = false
    @State private var unableToGenerateOutfit = false
    
    
    @State private var selectedEventTitle: String? = "Daily Outfit"
    
    
    var body: some View {
        ZStack {
            Image("sleekblack")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            NavigationStack {
                VStack() {
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 25)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
                        ZStack(alignment: .topLeading) {
                            Text(Date.now.formatted(.dateTime.weekday(.wide).day(.defaultDigits).month(.wide)))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.leading, 25)
                                .padding(.top, 20)
                            
                            ZStack {
                                List {
                                    Picker("Event", selection: $selectedEventTitle) {
                                        Text("Daily Outfit").tag("Daily Outfit")
                                        ForEach(calendarManager.events ,id: \.title) { event in
                                            Text(event.title.trimmingCharacters(in: .whitespaces)).tag(event.title.trimmingCharacters(in: .whitespaces))
                                        }
                                    }
                                    .labelsHidden()
                                }
                                .scrollDisabled(true)
                                .frame(minHeight: 85)
                                .scrollContentBackground(.hidden)
                                .offset(y: 19)
                            }
                        }                    }
                    .frame(height: 130)
                    .padding()
                    
                    Spacer()
                    Text(unableToGenerateOutfit ? "Unable to generate outfit" : "")
                        .foregroundStyle(.green)
                        .font(.system(size: 15, design: .monospaced))
                    
                    if dailyOutfitList != [] {
                        Text(dailyOutfitList[0].description)
                            .foregroundStyle(.green)
                            .font(.system(size: 15, design: .monospaced))
                        Text(dailyOutfitList[0].dailyOutfit.outfitStatus ?? "")
                            .foregroundStyle(.green)
                            .font(.system(size: 15, design: .monospaced))
                    }
                    
                    Button {
                        Task {
                            let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
                            
                            if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                                
                                let generatedOutfit = await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, previousOutfits: outfits, occasionTitle: "")
                                
                                context.insert(generatedOutfit)
                                print(generatedOutfit.outfitRationale ?? "")
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
        .onAppear() {

            print("onAppear opened")
            Task {
                if calendarManager.authorizationStatus == .notDetermined {
                    await calendarManager.requestAccess()
                    
                }
                
                calendarManager.fetchEvents()
                
                if let firstEventTitle = calendarManager.events.first?.title {
                    selectedEventTitle = firstEventTitle.trimmingCharacters(in: .whitespaces)
                } else {
                    selectedEventTitle = nil
                }
            }
            
            let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
            if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                if !Calendar.current.isDateInToday(dateLastOpened) {
                    var dailyOutfit: Outfit? = nil
                    var eventOutfits: [Outfit] = []
                    isGenerating = true
                    
                    while dailyOutfitList != [] {
                        context.delete(dailyOutfitList[0])
                        try? context.save()
                    }
                    
                    
                    Task {
                        if dailyOutfit == nil {
                            dailyOutfit = await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, previousOutfits: outfits, occasionTitle: "")
                        }
                        
                        if eventOutfits == [] {
                            calendarManager.fetchEvents()
                            for event in calendarManager.events {
                                eventOutfits.append(await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, previousOutfits: outfits, occasionTitle: event.title))
                            }
                        }
                        
                        context.insert(DailyOutfitList(dailyOutfit: dailyOutfit!, eventOutfits: eventOutfits))
                    }
                    
                    print("\nDay has changed\n")
                    while outfits.count >= 6 {
                        let outfitToRemove = outfits[5]
                        context.delete(outfitToRemove)
                    }
                    
                    isGenerating = false
                    unableToGenerateOutfit = false
                    dateLastOpened = Date()
                }
            } else {
                unableToGenerateOutfit = true
            }
        }
    }
}

#Preview {
    MainTabView()
}
