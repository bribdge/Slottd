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
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            VStack {
                HStack {
                    if let identifier = selectedEventIdentifier {
                        HStack {
                            eventHeaderInfo(identifier: identifier)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Text("Daily Outfit")
                                .font(.system(size: 24, weight: .bold))
                            Spacer()
                        }
                        .padding([.top, .leading], 20)
                    }
                    
                    actionButtons
                    
                }
                
                OutfitCardView(
                    eventIdentifier: selectedEventIdentifier,
                    isEditing: $isEditing,
                    isAnimating: $isAnimating, calendarManager: calendarManager,
                    selectedTop: $selectedTop,
                    selectedBottom: $selectedBottom,
                    selectedFootwear: $selectedFootwear,
                    selectedAccessories: $selectedAccessories,)
                
            }
        }
        .animation(.easeInOut, value: selectedEventIdentifier)
        .glassEffect(.regular.tint(.background.opacity(0.9)), in: RoundedRectangle(cornerRadius: 25))
        .padding([.leading, .trailing, .bottom])
        
        .onChange(of: selectedOutfit) {
            selectedTop = selectedOutfit?.top
            selectedBottom = selectedOutfit?.bottom
            selectedFootwear = selectedOutfit?.footwear
            if let accessories = selectedOutfit?.accessories {
                selectedAccessories = accessories
            }
        }
        
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
                finishEditing()
            }
        }
    }
    
    private func eventHeaderInfo(identifier: String) -> some View {
        VStack(alignment: .leading) {
            Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")
                .font(.system(size: 24, weight: .bold))
                .lineLimit(2)
            HStack {
                if let event = calendarManager.eventStore.event(withIdentifier: identifier) {
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
                }
            }
        }
        .padding([.top, .leading], 20)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 1) {
            Button {
                if isEditing {
                    finishEditingWithoutSaving()
                } else {
                    regenerateOutfit()
                }
            } label: {
                ZStack {
                    Image(systemName: "arrow.clockwise")
                        .opacity(notEditingButtonsOpacity)
                    
                    Image(systemName: "xmark")
                        .opacity(editingButtonsOpacity)
                    
                }
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
                .glassEffect(.clear.tint(isEditing ? .red : Color.button), in:
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 15,
                                    bottomLeadingRadius: 15,
                                    bottomTrailingRadius: 5,
                                    topTrailingRadius: 5
                                ))
            }
            
            
            Button {
                if isEditing {
                    finishEditing()
                } else {
                    beginEditing()
                }
            } label: {
                ZStack {
                    Image(systemName: "pencil")
                        .opacity(notEditingButtonsOpacity)
                    
                    Image(systemName: "checkmark")
                        .opacity(editingButtonsOpacity)
                    
                }
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
                .glassEffect(.clear.tint(isEditing ? .blue : Color.button), in:
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

    
    private func finishEditing() {
        selectedOutfit?.top = selectedTop
        selectedOutfit?.bottom = selectedBottom
        selectedOutfit?.footwear = selectedFootwear
        selectedOutfit?.accessories = selectedAccessories
        
        try? context.save()
        
        withAnimation(.easeInOut(duration: 0.15)) {
            notEditingButtonsOpacity = 1.0
            editingButtonsOpacity = 0.0
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditing = false
            isAnimating = false
        }
    }
    
    private func finishEditingWithoutSaving() {
        withAnimation(.easeInOut(duration: 0.15)) {
            notEditingButtonsOpacity = 1.0
            editingButtonsOpacity = 0.0
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditing = false
            isAnimating = false
        }
    }
    
    private func beginEditing() {
        withAnimation(.easeInOut(duration: 0.15)) {
            notEditingButtonsOpacity = 0.0
            editingButtonsOpacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isEditing = true
            isAnimating = true
        }
    }

    private func regenerateOutfit() {
        let separatedClothingItems = separateClothingByType(clothingItems: clothingItems)
        if separatedClothingItems.tops != [] && separatedClothingItems.bottoms != [] && separatedClothingItems.footwear != [] {
            
            withAnimation(.easeInOut(duration: 0.25)) {
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
}

#Preview {
    MainTabView()
}
