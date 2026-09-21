//
//  PlaceholderOutfitModuleView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 17/07/2026.
//

import SwiftUI
import EventKit
import SwiftData

struct PlaceholderOutfitModuleView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var calendarManager: CalendarManager
    @Binding var selectedEventIdentifier: String?
    @Binding var isGenerating: Bool
    @Binding var unableToGenerateOutfit: Bool
    
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
                                Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")
                                    .font(.system(size: 24, weight: .bold))
                                if let event = calendarManager.eventStore.event(withIdentifier: selectedEventIdentifier!) {
                                    Text(event.startDate, format: .dateTime.hour().minute())
                                } else {
                                    Text("No event selected")
                                }
                            }
                        } else {
                            Text("Daily Outfit")
                                .font(.system(size: 24, weight: .bold))
                        }
                        Spacer()
                        
                    }
                    .padding([.top, .leading], 20)
                    
                    Spacer()
                    
                    
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
                    .font(.system(size: 20, weight: .black))
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
        
    }
}

#Preview {
    MainTabView()
}
