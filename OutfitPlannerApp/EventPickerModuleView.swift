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
            .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 25))
        .frame(height: 120)
        .padding()
    }
 
}
