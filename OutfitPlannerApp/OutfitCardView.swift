//
//  OutfitCardView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 13/07/2026.
//

import SwiftUI
import EventKit
import SwiftData
import FoundationModels

struct OutfitCardView: View {
    @Query private var dailyOutfitList: [DailyOutfitList]
    
    var eventIdentifier: String?
    
    @Binding var isEditing: Bool
    @Binding var isAnimating: Bool
    
    var eventTitle: String? {
        if let identifier = eventIdentifier {
            return calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event"
        }
        return nil
    }
    
    var selectedOutfit: Outfit? {
        guard let daily = dailyOutfitList.first else {
            return nil
        }
        
        if eventTitle == nil {
            return daily.dailyOutfit
        }
        
        return daily.eventOutfits.first(where: { $0.occasionIdentifier == eventIdentifier })
    }
    
    var calendarManager: CalendarManager
    
    @Binding var selectedTop: ClothingItem?
    @Binding var selectedBottom: ClothingItem?
    @Binding var selectedFootwear: ClothingItem?
    @Binding var selectedAccessories: [ClothingItem]
    
    @State private var selectedEvent: EKEvent? = nil
    
    let model = SystemLanguageModel.default
    var modelAvailability: String? {
        switch model.availability {
            case .available:
                return nil
            case .unavailable(.deviceNotEligible):
                return "Smarter outfit generation isn't supported on this device. Apple Intelligence requires an iPhone 15 Pro or newer (or a compatible iPad/Mac) to run these models on-device. You can still use standard outfit generation without this feature."
            case .unavailable(.appleIntelligenceNotEnabled):
                return "Advanced outfit plans need Apple Intelligence turned on. Go to Settings > Apple Intelligence & Siri and enable Apple Intelligence, then come back here to try again. It may take a few minutes to finish setting up after you enable it."
            case .unavailable(.modelNotReady):
                return "The advanced generation model is still downloading or preparing on your device. This usually finishes within a few minutes, especially if you're on Wi-Fi and your device is charging. Feel free to check back shortly."
            default:
                return "The advanced generation model isn't available right now. Try closing and reopening the app, and if the issue continues, check that your device is updated to the latest iOS version and that Apple Intelligence is properly configured in Settings."
        }
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(spacing: 0) {

                OutfitItemScrollView(
                    selectedTop: $selectedTop,
                    selectedBottom: $selectedBottom,
                    selectedFootwear: $selectedFootwear,
                    selectedAccessories: $selectedAccessories,
                    isAnimating: $isAnimating,
                    isEditing: $isEditing)
                
                VStack(spacing: 6) {
                    if model.isAvailable {
                        HStack {
                            Label("Why this works", systemImage: "sparkles")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading)
                        ZStack(alignment: .topLeading) {
                            VStack {
                                Text(selectedOutfit?.rationale ?? "")
                                    .font(.system(size: 14))
                                    .padding()
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                        .background(.ultraThinMaterial)
                        .cornerRadius(17)
                    } else {
                        ZStack(alignment: .topLeading) {
                            HStack(spacing: 15) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.gray)
                                Text(modelAvailability ?? "")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                        .background(.ultraThinMaterial)
                        .cornerRadius(17)
                    }

                }
                .padding()
            }
        } // vertical scroll
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    MainTabView()
}
