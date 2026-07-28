//
//  DetailOutfitView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 21/07/2026.
//

import SwiftUI
import SwiftData
import EventKit

struct DetailOutfitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var calendarManager: CalendarManager
    var title: String
    var selectedOutfit: StarredOutfit
    
    @Query private var dailyOutfitList: [DailyOutfitList]
    @State private var selectedEventIdentifier: String? = nil
    
    var backgroundColor: Color {
        if colorScheme == .light {
            return Color(red: 0.98, green: 0.97, blue: 0.96)
        } else {
            return Color(red: 0.07, green: 0.05, blue: 0.04)
        }
    }
    
    var listColor: Color {
        if colorScheme == .light {
            return Color(red: 0.95, green: 0.94, blue: 0.93)
        } else {
            return Color(red: 0.11, green: 0.09, blue: 0.08)
        }
    }

    var body: some View {
        ZStack {
            Color.clear
            VStack {
                OutfitItemScrollView(
                    top: selectedOutfit.top,
                    bottom: selectedOutfit.bottom,
                    footwear: selectedOutfit.footwear,
                    accessories: selectedOutfit.accessories)
                .padding(.top)
                
                if let rationale = selectedOutfit.rationale {
                    VStack {
                        HStack {
                            Label("Why this works", systemImage: "sparkles")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading)
                        VStack {
                            Text(rationale)
                                .font(.system(size: 14))
                                .padding()
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                        .background(.ultraThinMaterial)
                        .cornerRadius(17)
                    }
                    .padding([.leading, .trailing, .top])
                }
                VStack {
                    HStack {
                        Text("Wear this outfit")
                            .font(.system(size: 17, weight: .bold))
                            .padding([.top, .leading, .trailing])
                        Spacer()
                    }
                    if dailyOutfitList != [] {
                        HStack {
                            Text("Occasion")
                                .padding(.leading)
                                .padding(3)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Picker("Outfit", selection: $selectedEventIdentifier) {
                                    Label(" Daily Outfit", systemImage: "calendar").tag(nil as String?)
                                    ForEach(calendarManager.events ,id: \.eventIdentifier) { event in
                                        Text(event.title.trimmingCharacters(in: .whitespaces)).tag(event.eventIdentifier as String?)
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .frame(minWidth: 60, maxWidth: 200)
                            .padding(.leading)
                            .padding([.top, .bottom], 3)
                        }
                        .frame(height: 60)
                        .background(backgroundColor)
                        .cornerRadius(50)
                        .padding([.leading, .trailing])
                    } else {
                        HStack {
                            Text("Daily Outfit")
                                .padding(.leading)
                                .padding([.top, .bottom], 3)
                            
                            Spacer()
                        }
                        .frame(height: 60)
                        .background(.ultraThinMaterial)
                        .cornerRadius(50)
                        .padding([.leading, .trailing])
                    }
                    
                    
                    Button {
                        if selectedEventIdentifier == nil {
                            dailyOutfitList[0].dailyOutfit = convertStarredOutfitToOutfit(starredOutfit: selectedOutfit)
                        } else {
                            if let editingOutfit = dailyOutfitList[0].eventOutfits.first(where: { $0.occasionIdentifier == selectedEventIdentifier }) {
                                if editingOutfit == convertStarredOutfitToOutfit(starredOutfit: selectedOutfit) {
                                    editingOutfit.top = selectedOutfit.top
                                    editingOutfit.bottom = selectedOutfit.bottom
                                    editingOutfit.footwear = selectedOutfit.footwear
                                    editingOutfit.accessories = selectedOutfit.accessories
                                    editingOutfit.rationale = nil
                                    editingOutfit.id = selectedOutfit.sourceID
                                }
                            }
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Confirm")
                                .font(.system(size: 17))
                            Spacer()
                        }
                        .frame(height: 40)
                    }
                    .buttonStyle(.glassProminent)
                    .padding([.bottom, .leading, .trailing])
                    
                }
                .background(.ultraThinMaterial)
                .cornerRadius(17)
                .padding()
                Spacer()
            }
            .navigationTitle(title)
        }
        .background(backgroundColor)
        

    }
    
    private func convertStarredOutfitToOutfit(starredOutfit: StarredOutfit) -> Outfit {
        return Outfit(
            top: starredOutfit.top,
            bottom: starredOutfit.bottom,
            accessories: starredOutfit.accessories,
            footwear: starredOutfit.footwear,
            occasionIdentifier: nil,
            rationale: starredOutfit.rationale,
            isValid: true,
            isStarred: true,
            isLockedIn: true,
            id: selectedOutfit.sourceID)
    }
}

#Preview {
    NavigationStack {
        DetailOutfitView(calendarManager: CalendarManager(), title: "hello", selectedOutfit: StarredOutfit(name: "d", top: nil, bottom: nil, accessories: [], footwear: nil, occasionIdentifier: nil, rationale: nil, sourceID: UUID()))
    }
}
