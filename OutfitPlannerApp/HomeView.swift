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
        ZStack {
            NavigationStack {
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
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
                                                ForEach(calendarManager.events ,id: \.eventIdentifier) { event in
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
                                                VStack {
                                                    Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")
                                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                                    if let event = calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier!) {
                                                        Text(event.startDate, format: .dateTime.hour().minute())
                                                    } else {
                                                        Text("No event selected")
                                                    }
                                                }
                                            } else {
                                                Text("Daily Outfit")
                                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                            }
                                            Spacer()
                                            
                                        }
                                        .padding([.top, .leading], 20)
                                        
                                        OutfitCardView(eventIdentifier: selectedEventIdentifier, calendarManager: calendarManager)
                                        
                                        
                                        HStack(spacing: 10) {
                                            Button {
                                                
                                            } label: {
                                                Text("Regenerate")
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundStyle(buttonColor)
                                                
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
                                            .background(buttonColor)
                                            .clipShape(.capsule)
                                            .padding([.bottom], 10)
                                        }
                                        
                                    }
                                }
                                .blur(radius: 40)
                                
                                if isGenerating {
                                    Text("Generating your outfit...")
                                        .font(.system(size: 20, weight: .black, design: .rounded))
                                } else if unableToGenerateOutfit {
                                    VStack(spacing: 10) {
                                        Image(systemName: "tshirt")
                                            .font(.system(size: 70))
                                            .padding()
                                        Text("Your closet's a little empty.")
                                            .font(.system(size: 25, weight: .bold))
                                            .multilineTextAlignment(.center)
                                        Text("Try adding some more clothing items in the 'Clothing' tab to get started.")
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
                                                VStack {
                                                    HStack {
                                                        Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")
                                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                                        Spacer()
                                                    }
                                                    HStack {
                                                        if let event = calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier!) {
                                                            HStack {
                                                                Image(systemName: "clock")
                                                                Text("\(event.startDate, format: .dateTime.hour().minute()) - \(event.endDate, format: .dateTime.hour().minute())")
                                                                Spacer()
                                                            }
                                                        }
                                                    }
                                                }
                                                .padding([.top, .leading], 20)
                                            } else {
                                                HStack {
                                                    Text("Daily Outfit")
                                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                                    Spacer()
                                                }
                                                .padding([.top, .leading], 20)
                                            }
                                            

                                            Button {
                                                let pressImpact = UIImpactFeedbackGenerator(style: .medium)
                                                pressImpact.impactOccurred()
                                                
                                                selectedOutfit?.isStarred.toggle()
                                            } label: {
                                                Image((systemName: selectedOutfit?.isStarred ? "star.fill" : "star") ?? "star")
                                                    .foregroundStyle(.white)
                                                    .padding(7)
                                                    .glassEffect(.regular.interactive().tint(buttonColor), in: .circle)
                                            }
                                            .padding([.top, .trailing], 20)
                                            
                                        }
                                        
                                        
                                        OutfitCardView(eventIdentifier: selectedEventIdentifier, calendarManager: calendarManager)
                                        
                                        if (selectedEventIdentifier != nil ?
                                            !(dailyOutfitList.first?.eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier })?.isLockedIn ?? false)
                                            :
                                                !(dailyOutfitList.first?.dailyOutfit.isLockedIn ?? false)) {
                                            
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
                                                        .foregroundStyle(buttonColor)
                                                    
                                                }
                                                .padding([.leading, .trailing], 30)
                                                .padding([.top, .bottom], 7)
                                                .background(.ultraThinMaterial)
                                                .clipShape(.capsule)
                                                .padding([.bottom], 10)
                                                
                                                
                                                Button {
                                                    if selectedEventIdentifier != nil {
                                                        let editingOutfitIndex = dailyOutfitList.first?.eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier
                                                        })
                                                        withAnimation() {
                                                            editingOutfitIndex?.isLockedIn = true
                                                        }
                                                    } else {
                                                        let editingOutfitIndex = dailyOutfitList.first?.dailyOutfit
                                                        withAnimation() {
                                                            editingOutfitIndex?.isLockedIn = true
                                                        }
                                                    }
                                                    
                                                    try? context.save()
                                                } label: {
                                                    Text("Looks Good!")
                                                        .font(.system(size: 15, weight: .bold))
                                                        .foregroundStyle(.white)
                                                    
                                                    
                                                }
                                                .padding([.leading, .trailing], 30)
                                                .padding([.top, .bottom], 7)
                                                .background(buttonColor)
                                                .clipShape(.capsule)
                                                .padding([.bottom], 10)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                            } .animation(.easeInOut, value: selectedEventIdentifier)
                                .frame(minHeight: 300, maxHeight: 500)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
                                .padding([.leading, .trailing, .bottom])
                        }
                        
                    }
                    .navigationTitle("Today's Outfits")
                    
                }
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
                withAnimation() {
                    isGenerating = true
                }
                let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
                if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
                    var dailyOutfit: Outfit? = nil
                    var eventOutfits: [Outfit] = []

                    
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
                        
                        withAnimation() {
                            isGenerating = false
                        }
                    }
                    

                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                regenerateOutfitsIfNewDay()
            }
        }
        .onAppear {
            Task {
                if calendarManager.authorizationStatus == .notDetermined {
                    await calendarManager.requestAccess()
                }
                calendarManager.fetchEvents()
                regenerateOutfitsIfNewDay()
            }
        }

    }
    
    private func regenerateOutfitsIfNewDay() {
        let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
        guard !separatedClothingItems.tops.isEmpty,
              !separatedClothingItems.bottoms.isEmpty,
              !separatedClothingItems.footwear.isEmpty else {
            unableToGenerateOutfit = true
            return
        }
        unableToGenerateOutfit = false

        guard !Calendar.current.isDateInToday(dateLastOpened) else { return }

        withAnimation { isGenerating = true }

        while !dailyOutfitList.isEmpty {
            context.delete(dailyOutfitList[0])
            try? context.save()
        }

        Task {
            calendarManager.fetchEvents()

            let dailyOutfit = await generateDailyOutfit(
                tops: separatedClothingItems.tops,
                bottoms: separatedClothingItems.bottoms,
                footwear: separatedClothingItems.footwear,
                accessories: separatedClothingItems.misc,
                occasionTitle: "",
                occasionIdentifier: nil
            )

            var eventOutfits: [Outfit] = []
            for event in calendarManager.events {
                eventOutfits.append(await generateDailyOutfit(
                    tops: separatedClothingItems.tops,
                    bottoms: separatedClothingItems.bottoms,
                    footwear: separatedClothingItems.footwear,
                    accessories: separatedClothingItems.misc,
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
