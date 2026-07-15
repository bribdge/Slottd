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
    var unableToGenerateOutfit: Bool {
        let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
        if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
            return false
        }
        
        return true
    }
    
    
    @State private var selectedEventIdentifier: String? = nil
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack() {
                    
                    ZStack() {

                        ZStack(alignment: .topLeading) {
                            Text(Date.now.formatted(.dateTime.weekday(.wide).day(.defaultDigits).month(.wide)))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.leading, 25)
                                .padding(.top, 20)
                            
                            ZStack {
                                List {
                                    if calendarManager.events != [] {
                                        Picker("Occasion", selection: $selectedEventIdentifier) {
                                            Label(" Daily Outfit", systemImage: "calendar").tag(nil as String?)
                                            ForEach(calendarManager.events ,id: \.title) { event in
                                                Text(event.title.trimmingCharacters(in: .whitespaces)).tag(event.eventIdentifier as String?)
                                            }
                                        }
                                    } else {
                                        Text("Daily Outfit")
                                    }
                                }
                                .scrollDisabled(true)
                                .frame(minHeight: 85)
                                .scrollContentBackground(.hidden)
                                .offset(y: 50)
                            }
                        }
                    }
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
                    .frame(height: 120)
                    .padding()
                    
                    if isGenerating || unableToGenerateOutfit {
                        
                        ZStack {
                            ZStack(alignment: .topLeading) {
                                Color.clear
                                VStack {
                                    HStack {
                                        if let identifier = selectedEventIdentifier {
                                            Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")

                                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                        } else {
                                            Text("Daily Outfit")
                                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                        }
                                        Image(systemName: "chevron.right")
                                        Spacer()
                                        
                                    }
                                    .padding([.top, .leading], 20)
                                    
                                    OutfitCardView(eventIdentifier: selectedEventIdentifier, calendarManager: calendarManager)
                                    
                                    if ((dailyOutfitList.first?.eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier
                                    })?.isLockedIn) == nil) {
                                        HStack(spacing: 10) {
                                            Button {
                                                
                                            } label: {
                                                Text("Regenerate")
                                                    .font(.system(size: 15, weight: .bold))
                                                
                                            }
                                            .padding([.leading, .trailing], 30)
                                            .padding([.top, .bottom], 7)
                                            .background(.ultraThinMaterial)
                                            .clipShape(.capsule)
                                            .padding([.bottom], 10)
                                            
                                            
                                            Button {
                                                
                                            } label: {
                                                Text("Looks Good!")
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundStyle(.white)
                                                
                                                
                                            }
                                            .padding([.leading, .trailing], 30)
                                            .padding([.top, .bottom], 7)
                                            .background(.blue)
                                            .clipShape(.capsule)
                                            .padding([.bottom], 10)
                                        }
                                    }
                                    
                                }
                            }
                            .blur(radius: 40)
                            
                            if isGenerating {
                                Text("Generating your outfit...")
                                    .font(.system(size: 20, weight: .black, design: .rounded))
                            }
                            if unableToGenerateOutfit {
                                VStack(spacing: 10) {
                                    Image(systemName: "tshirt")
                                        .font(.system(size: 70))
                                        .padding()
                                    Text("Your closet's a little empty.")
                                        .font(.system(size: 25, weight: .bold))
                                        .multilineTextAlignment(.center)
                                    Text("Try adding some clothing items in the 'Clothing' tab to get started.")
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(30)
                            }
                        }
                        
                    } else {
                        
                        ZStack {
                            ZStack(alignment: .topLeading) {
                                Color.clear
                                VStack {
                                    HStack {
                                        if let identifier = selectedEventIdentifier {
                                            Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")

                                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                        } else {
                                            Text("Daily Outfit")
                                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                        }
                                        Image(systemName: "chevron.right")
                                        Spacer()
                                        
                                    }
                                    .padding([.top, .leading], 20)
                                    
                                    OutfitCardView(eventIdentifier: selectedEventIdentifier, calendarManager: calendarManager)
                                    
                                    HStack(spacing: 10) {
                                        Button {
                                            
                                            let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
                                            if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                                                
                                                withAnimation() {
                                                    isGenerating = true
                                                }
                                                
                                                Task {
                                                    if selectedEventIdentifier != nil {
                                                        guard let editingOutfitIndex = dailyOutfitList.first?.eventOutfits.firstIndex(where: { $0.occasionIdentifier == selectedEventIdentifier
                                                        }) else {
                                                            withAnimation() {
                                                                isGenerating = false
                                                            }
                                                            print("Couldn't find event outfit")
                                                            return
                                                        }
                                                        
                                                        let generatedOutfit = await generateDailyOutfit(tops: separatedClothingItems.tops,
                                                          bottoms: separatedClothingItems.bottoms,
                                                          footwear: separatedClothingItems.footwear,
                                                          accessories: [],
                                                          occasionTitle: calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier ?? "")?.title ?? "Unknown Event",
                                                          occasionIdentifier: selectedEventIdentifier)
                                                        
                                                        dailyOutfitList[0].eventOutfits[editingOutfitIndex] = generatedOutfit
                                                        
                                                        try? context.save()
                                                    } else {
                                                        let generatedOutfit = await generateDailyOutfit(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: [], occasionTitle: "", occasionIdentifier: nil)
                                                        
                                                        dailyOutfitList[0].dailyOutfit = generatedOutfit
                                                        
                                                        try? context.save()
                                                    }
                                                    
                                                    withAnimation() {
                                                        isGenerating = false
                                                    }
                                                    
                                                }
                    
                                            }
                                            
                                        } label: {
                                            Text("Regenerate")
                                                .font(.system(size: 15, weight: .bold))
                                            
                                        }
                                        .padding([.leading, .trailing], 30)
                                        .padding([.top, .bottom], 7)
                                        .background(.ultraThinMaterial)
                                        .clipShape(.capsule)
                                        .padding([.bottom], 10)
                                        
                                        
                                        Button {
                                            if selectedEventIdentifier != nil {
                                                guard let editingOutfitIndex = dailyOutfitList.first?.eventOutfits.firstIndex(where: { $0.occasionIdentifier == selectedEventIdentifier
                                                }) else {
                                                    print("Couldn't find event outfit")
                                                    return
                                                }
                                            } else {
                                                
                                            }
                                        } label: {
                                            Text("Looks Good!")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundStyle(.white)
                                            
                                            
                                        }
                                        .padding([.leading, .trailing], 30)
                                        .padding([.top, .bottom], 7)
                                        .background(.blue)
                                        .clipShape(.capsule)
                                        .padding([.bottom], 10)
                                    }
                                    
                                }
                                
                            }
                                
                        } .animation(.easeInOut, value: selectedEventIdentifier)
                            .frame(minHeight: 300, maxHeight: 500)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
                            .padding([.leading, .trailing, .bottom])
                    }
                        

                    
//                    Button {
//                        var dailyOutfit: Outfit? = nil
//                        var eventOutfits: [Outfit] = []
//

//
//                            
//                            while dailyOutfitList != [] {
//                                context.delete(dailyOutfitList[0])
//                                try? context.save()
//                            }
//                            
//                            Task {
//                                if calendarManager.authorizationStatus == .notDetermined {
//                                    await calendarManager.requestAccess()
//                                    
//                                }
//                                
//                                calendarManager.fetchEvents()
//                                
//                                if let firstEventTitle = calendarManager.events.first?.title {
//                                    selectedEventTitle = firstEventTitle.trimmingCharacters(in: .whitespaces)
//                                } else {
//                                    selectedEventTitle = nil
//                                }
//                            }
//                            Task {
//                                if dailyOutfit == nil {
//                                    dailyOutfit = await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, occasionTitle: "")
//                                }
//                                
//                                if eventOutfits == [] {
//                                    calendarManager.fetchEvents()
//                                    for event in calendarManager.events {
//                                        eventOutfits.append(await generateDailyOutfitAI(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, occasionTitle: event.title.trimmingCharacters(in: .whitespacesAndNewlines)))
//                                    }
//                                }
//                                
//                                context.insert(DailyOutfitList(dailyOutfit: dailyOutfit!, eventOutfits: eventOutfits))
//                                
//                                withAnimation() {
//                                    isGenerating = false
//                                }
//                            }
//                        }
//
//                    } label: {
//                        Text("Force-Generate Outfit")
//                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Today's Outfits")
                
            }
        }
        
        
        .onAppear() {
            Task {
                if calendarManager.authorizationStatus == .notDetermined {
                    await calendarManager.requestAccess()
                    
                }
                
                calendarManager.fetchEvents()
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
                            dailyOutfit = await generateDailyOutfit(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, occasionTitle: "", occasionIdentifier: nil)
                        }
                        
                        if eventOutfits == [] {
                            calendarManager.fetchEvents()
                            for event in calendarManager.events {
                                eventOutfits.append(await generateDailyOutfit(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.misc, occasionTitle: event.title.trimmingCharacters(in: .whitespacesAndNewlines), occasionIdentifier: event.eventIdentifier))
                            }
                        }
                        
                        context.insert(DailyOutfitList(dailyOutfit: dailyOutfit!, eventOutfits: eventOutfits))
                    }
                    
                    isGenerating = false
                    dateLastOpened = Date()
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
