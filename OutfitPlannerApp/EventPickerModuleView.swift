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
            VStack(alignment: .leading) {
                Text(Date.now.formatted(.dateTime.weekday(.wide).day(.defaultDigits).month(.wide)))
                    .font(.system(size: 18, weight: .bold))
                
                HStack {
                    Text("Occasion")
                    Spacer()
                    if calendarManager.events != [] {
                        Picker("Occasion", selection: $selectedEventIdentifier) {
                            Text("Daily Outfit").tag(nil as String?)
                            ForEach(calendarManager.events ,id: \.eventIdentifier) { event in
                                
                                let eventTitle = event.title.trimmingCharacters(in: .whitespaces)
                                Text(eventTitle.count > 20 ? String(eventTitle.prefix(20)) + "..."
                                     :
                                  eventTitle
                                )
                                .tag(event.eventIdentifier as String?)
                            }
                        }
                    } else {
                        Text("No Events Today")
                    }
                }
                .padding([.leading, .trailing])
                .padding([.top, .bottom], 10)
                .glassEffect()
            
            }
            .padding()
            .glassEffect(.regular.tint(.background), in: RoundedRectangle(cornerRadius: 25))
        .padding()
    }
 
}

#Preview {
    MainTabView()
}
