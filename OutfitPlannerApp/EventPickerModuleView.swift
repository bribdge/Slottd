    //
    //  EventPickerModuleView.swift
    //  OutfitPlannerApp
    //
    //  Created by Vedant Ganpule on 17/07/2026.
    //
     
    import SwiftUI
    import EventKit
     
     
    struct EventPickerModuleView: View {
        @Environment(\.colorScheme) private var colorScheme
        var calendarManager: CalendarManager
        @Binding var selectedEventIdentifier: String?
     
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
            ZStack(alignment: .topLeading) {
                Text(Date.now.formatted(.dateTime.weekday(.wide).day(.defaultDigits).month(.wide)))
                    .font(.system(size: 18, weight: .bold))
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
                            Text("No Events Today")
                        }
                    }
                    .scrollDisabled(true)
                    .frame(minHeight: 85)
                    .scrollContentBackground(.hidden)
                    .offset(y: 50)
                }
            }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
        .frame(height: 120)
        .padding()
    }
 
}
