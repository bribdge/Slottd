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
    
    var eventTitle: String? {
        if let identifier = eventIdentifier {
            return calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event"
        }
        return nil
    }
    
    var calendarManager: CalendarManager
    
    var selectedOutfit: Outfit? {
        guard let daily = dailyOutfitList.first else {
            return nil
        }
        
        if eventTitle == nil {
            return daily.dailyOutfit
        }
        
        return daily.eventOutfits.first(where: { $0.occasionIdentifier == eventIdentifier })
    }
    @State private var selectedEvent: EKEvent? = nil
    
    let model = SystemLanguageModel.default
    var modelAvalibility: String? {
        switch model.availability {
            case .available:
                return nil
            case .unavailable(.deviceNotEligible):
                return "Your device does not support smarter outfit generation."
            case .unavailable(.appleIntelligenceNotEnabled):
                return "Please enable Apple Intelligence in Settings to get advanced outfit plans."
            case .unavailable(.modelNotReady):
                return "The advanced generation model is currently preparing."
            default:
                return "The advanced generation model is currently unavaliable."
        }
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        if let selectedImageData = selectedOutfit?.top?.image,
                           let uiImage = UIImage(data: selectedImageData) {
                            VStack(spacing: 10) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(25)
                                Text(selectedOutfit?.top?.name ?? "")
                                    .frame(width: 125)
                                    .lineLimit(1)
                                    .font(.system(size: 14))
                                
                            }
                            .padding(.leading)
                        } else {
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 150, height: 150)
                                        .opacity(0.5)
                                        .blur(radius: 5)
                                    Image(systemName: "photo.trianglebadge.exclamationmark")
                                        .font(.system(size: 40, weight: .regular))
                                        .offset(y: -5)
                                }
                                Text(selectedOutfit?.top?.name ?? "")
                                    .frame(width: 125)
                                    .lineLimit(1)
                                    .font(.system(size: 14))
                            }
                            .padding(.leading)
                        }
                        
                        if selectedOutfit?.bottom != nil {
                            if let selectedImageData = selectedOutfit?.bottom?.image,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(25)
                                    Text(selectedOutfit?.bottom?.name ?? "")
                                        .frame(width: 125)
                                        .lineLimit(1)
                                        .font(.system(size: 14))
                                }
                            } else {
                                VStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(width: 150, height: 150)
                                            .opacity(0.5)
                                            .blur(radius: 5)
                                        Image(systemName: "photo.trianglebadge.exclamationmark")
                                            .font(.system(size: 40, weight: .regular))
                                            .offset(y: -5)
                                    }
                                    Text(selectedOutfit?.bottom?.name ?? "")
                                        .frame(width: 125)
                                        .lineLimit(1)
                                        .font(.system(size: 14))
                                }
                            }
                        }
                        
                        if let selectedImageData = selectedOutfit?.footwear?.image,
                           let uiImage = UIImage(data: selectedImageData) {
                            VStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(25)
                                Text(selectedOutfit?.footwear?.name ?? "")
                                    .frame(width: 125)
                                    .lineLimit(1)
                                    .font(.system(size: 14))
                            }
                        } else {
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 150, height: 150)
                                        .opacity(0.5)
                                        .blur(radius: 5)
                                    Image(systemName: "photo.trianglebadge.exclamationmark")
                                        .font(.system(size: 40, weight: .regular))
                                        .offset(y: -5)
                                }
                                Text(selectedOutfit?.footwear?.name ?? "")
                                    .frame(width: 125)
                                    .lineLimit(1)
                                    .font(.system(size: 14))
                            }
                        }
                        
                        if selectedOutfit?.accessories != [] {
                            AccessoriesCardView(selectedOutfit: selectedOutfit)
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                VStack(spacing: 6) {
                    if model.isAvailable {
                        HStack {
                            Label("Why this works", systemImage: "sparkles")
                                .font(.system(size: 17, weight: .bold))
                            Spacer()
                        }
                        .padding(.leading)
                    }

                    ZStack(alignment: .topLeading) {
                        if model.isAvailable {
                            VStack {
                                Text(selectedOutfit?.rationale ?? "")
                                    .font(.system(size: 14))
                                    .padding()
                            }
                        } else {
                            VStack {
                                HStack(spacing: 15) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.gray)
                                    Text(modelAvalibility ?? "")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.gray)
                                }
                                .padding()
                            }
                        }
                    }
                    .frame(minWidth: 300, maxWidth: 500)
                    .background(.ultraThinMaterial)
                    .cornerRadius(17)
                }
                .padding()
            }
        } // vertical scroll
        .scrollIndicators(.hidden)

    }
}

#Preview {
    OutfitCardView(calendarManager: CalendarManager())
}
