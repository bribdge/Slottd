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
    @Query private var starredOutfits: [StarredOutfit]
    @Query private var clothingItems: [ClothingItem]

    @Binding var isGenerating: Bool
    
    @State private var notEditingButtonsOpacity = 1.0
    @State private var editingButtonsOpacity = 0.0
    
    @State private var isAnimating = false
    @State private var isEditing = false

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
    
    @State private var selectedTop: ClothingItem? = nil
    @State private var selectedBottom: ClothingItem? = nil
    @State private var selectedFootwear: ClothingItem? = nil
    @State private var selectedAccessories: [ClothingItem] = []

    var backgroundColor: Color {
        if colorScheme == .light {
            return Color(red: 0.98, green: 0.97, blue: 0.96) 
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
                                        .font(.system(size: 24, weight: .bold))
                                    Spacer()
                                }
                                HStack {
                                    if let event = calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier!) {
                                        HStack {
                                            Image(systemName: "clock")
                                                .foregroundStyle(.gray)
                                                .font(.system(size: 15, weight: .regular, design: .default))
                                            Text(event.isAllDay ?
                                                 "All Day"
                                                 :
                                                    "\(event.startDate, format: .dateTime.hour().minute()) - \(event.endDate, format: .dateTime.hour().minute())"
                                            )
                                            .foregroundStyle(.gray)
                                            .font(.system(size: 15, weight: .regular, design: .default))
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding([.top, .leading], 20)
                        } else {
                            HStack {
                                Text("Daily Outfit")
                                    .font(.system(size: 24, weight: .bold))
                                Spacer()
                            }
                            .padding([.top, .leading], 20)
                        }
                        
                        HStack(spacing: 1) {
                            Button {
                                if !isEditing {
                                    let pressImpact = UIImpactFeedbackGenerator(style: .medium)
                                    pressImpact.impactOccurred()
                                    
                                    if selectedOutfit?.isStarred == true {
                                        selectedOutfit?.isStarred = false
                                        if let starredOutfit = starredOutfits.first(where: { $0.sourceID == selectedOutfit?.id }) {
                                            context.delete(starredOutfit)
                                            
                                            try? context.save()
                                        }
                                    } else {
                                        selectedOutfit?.isStarred = true
                                        if let convertedOutfit = convertOutfitToStarredOutfit(outfit: selectedOutfit, occassionTitle: selectedEventIdentifier == nil ? nil : calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier!)?.title) {
                                            context.insert(convertedOutfit)
                                            
                                            try? context.save()
                                        }
                                    }
                                } else {
                                    selectedTop = selectedOutfit?.top
                                    selectedBottom = selectedOutfit?.bottom
                                    selectedFootwear = selectedOutfit?.footwear
                                    
                                    if let accessories = selectedOutfit?.accessories {
                                        selectedAccessories = accessories
                                    }
                                    
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        notEditingButtonsOpacity = isEditing ? 1.0 : 0.0
                                        editingButtonsOpacity = isEditing ? 0.0 : 1.0
                                    }
                                    
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isEditing = false
                                        isAnimating = false
                                    }
                                }
                            } label: {
                                ZStack {
                                    Image(systemName: (selectedOutfit?.isStarred == true) ? "star.fill" : "star")
                                        .opacity(notEditingButtonsOpacity)
                                    
                                    Image(systemName: "xmark")
                                        .opacity(editingButtonsOpacity)
                                }
                                .frame(width: isEditing ? 60 : 40, height: 40)
                                .foregroundStyle(.white)
                                .glassEffect(.clear.tint(isEditing ? .red : buttonColor), in:
                                                UnevenRoundedRectangle(
                                                    topLeadingRadius: 15,
                                                    bottomLeadingRadius: 15,
                                                    bottomTrailingRadius: 5,
                                                    topTrailingRadius: 5
                                                ))
                                
                            }
                            .shadow(color: buttonColor, radius: (isEditing ? 0 : (selectedOutfit?.isStarred ?? false) ? 7 : 0))
                            
                            Button {
                                regenerateOutfit()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .opacity(notEditingButtonsOpacity)
                                    .frame(width: isEditing ? 0 : 40, height: 40)
                                    .foregroundStyle(.white)
                                    .glassEffect(.clear.tint(buttonColor), in: RoundedRectangle(cornerRadius: 5))
                            }

                            
                            Button {
                                if isEditing {
                                    selectedOutfit?.top = selectedTop
                                    selectedOutfit?.bottom = selectedBottom
                                    selectedOutfit?.footwear = selectedFootwear
                                    
                                    selectedOutfit?.accessories = selectedAccessories
                                }
                                
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    notEditingButtonsOpacity = isEditing ? 1.0 : 0.0
                                    editingButtonsOpacity = isEditing ? 0.0 : 1.0
                                }
                                
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isEditing = isEditing ? false : true
                                    isAnimating = isAnimating ? false : true
                                }
                                
                                
                            } label: {
                                ZStack {
                                    Image(systemName: "pencil")
                                        .opacity(notEditingButtonsOpacity)
                                    
                                    Image(systemName: "checkmark")
                                        .opacity(editingButtonsOpacity)
                                        
                                }
                                .frame(width: isEditing ? 60 : 40, height: 40)
                                .foregroundStyle(.white)
                                .glassEffect(.clear.tint(isEditing ? .blue : buttonColor), in:
                                                UnevenRoundedRectangle(
                                                    topLeadingRadius: 5,
                                                    bottomLeadingRadius: 5,
                                                    bottomTrailingRadius: 15,
                                                    topTrailingRadius: 15
                                                ))
                            }
                            
                        }
                        .padding([.top, .trailing])
                    }
                    OutfitCardView(
                        eventIdentifier: selectedEventIdentifier,
                        isEditing: $isEditing,
                        isAnimating: $isAnimating, calendarManager: calendarManager,
                        selectedTop: $selectedTop,
                        selectedBottom: $selectedBottom,
                        selectedFootwear: $selectedFootwear,
                        selectedAccessories: $selectedAccessories,)

                    
                    if (selectedEventIdentifier != nil ?
                        !(dailyOutfitList.first?.eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier })?.isLockedIn ?? false)
                        :
                            !(dailyOutfitList.first?.dailyOutfit.isLockedIn ?? false)) {
                    }
                }
            }
        }
        
        .animation(.easeInOut, value: selectedEventIdentifier)
        .frame(minHeight: 300, maxHeight: 500)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
        .padding([.leading, .trailing, .bottom])
        
        .onAppear() {
            if !isEditing {
                selectedTop = selectedOutfit?.top
                selectedBottom = selectedOutfit?.bottom
                selectedFootwear = selectedOutfit?.footwear
                
                if let accessories = selectedOutfit?.accessories {
                    selectedAccessories = accessories
                }
            }
        }
        .onDisappear() {
            if isEditing {
                selectedTop = selectedOutfit?.top
                selectedBottom = selectedOutfit?.bottom
                selectedFootwear = selectedOutfit?.footwear
                
                if let accessories = selectedOutfit?.accessories {
                    selectedAccessories = accessories
                }
                
                withAnimation(.easeInOut(duration: 0.15)) {
                    notEditingButtonsOpacity = isEditing ? 1.0 : 0.0
                    editingButtonsOpacity = isEditing ? 0.0 : 1.0
                }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    isEditing = false
                    isAnimating = false
                }
            }
            print("disappeared")
        }
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
                        return
                    }
                    
                    let generatedOutfit = await generateDailyOutfit(
                        tops: separatedClothingItems.tops,
                        bottoms: separatedClothingItems.bottoms,
                        footwear: separatedClothingItems.footwear,
                        accessories: separatedClothingItems.accessories,
                        occasionTitle: calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier ?? "")?.title ?? "Unknown Event",
                        occasionIdentifier: selectedEventIdentifier)

                    dailyOutfitList[0].eventOutfits[editingOutfitIndex] = generatedOutfit
                    
                    try? context.save()
                } else {
                    let generatedOutfit = await generateDailyOutfit(tops: separatedClothingItems.tops, bottoms: separatedClothingItems.bottoms, footwear: separatedClothingItems.footwear, accessories: separatedClothingItems.accessories, occasionTitle: "", occasionIdentifier: nil)
                    
                    dailyOutfitList[0].dailyOutfit = generatedOutfit
                    
                    try? context.save()
                }
                withAnimation() {
                    isGenerating = false
                }
            }
        }
    }
    
    private func convertOutfitToStarredOutfit(outfit: Outfit?, occassionTitle: String?) -> StarredOutfit? {
        guard let outfit else { return nil }
        
        let returningOutfit = StarredOutfit(
            name: occassionTitle == nil ? "Outfit" : "\(occassionTitle.unsafelyUnwrapped) Outfit",
            top: outfit.top,
            bottom: outfit.bottom,
            accessories: outfit.accessories,
            footwear: outfit.footwear,
            occasionIdentifier: outfit.occasionIdentifier,
            rationale: outfit.rationale,
            sourceID: outfit.id)
        
        return returningOutfit
    }
}

#Preview {
    MainTabView()
}
