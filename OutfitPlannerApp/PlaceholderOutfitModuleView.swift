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
    var calendarManager: CalendarManager
    @Binding var selectedEventIdentifier: String?
    
    var body: some View {
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
        .blur(radius: 25)
    }
}

#Preview {
    MainTabView()
}
