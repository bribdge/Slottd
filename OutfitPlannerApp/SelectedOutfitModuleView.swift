//
//  SelectedOutfitModuleView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 17/07/2026.
//

import SwiftUI
import EventKit
import SwiftData

struct SelectedOutfitModuleView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context

    @Query private var dailyOutfitList: [DailyOutfitList]
    @Query private var clothingItems: [ClothingItem]

    @Binding var isGenerating: Bool

    var calendarManager: CalendarManager
    @Binding var selectedEventIdentifier: String?

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
                            Image(systemName: "star")
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

                                regenerateOutfit()
                                
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









    private func regenerateOutfit() {
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
                    
                    let generatedOutfit = await generateDailyOutfit(
                        tops: separatedClothingItems.tops,
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
    }

}

#Preview {
    MainTabView()
}
