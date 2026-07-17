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
                return Color(red: 0.98, green: 0.97, blue: 0.93)
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
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.leading, 25)
                    .padding(.top, 20)
     
                picker
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 25))
            .frame(height: 120)
            .padding()
        }
     
        @ViewBuilder
        private var picker: some View {
            if calendarManager.events != [] {
                List {
                    Picker("Occasion", selection: $selectedEventIdentifier) {
                        Label(" Daily Outfit", systemImage: "calendar").tag(nil as String?)
                        ForEach(calendarManager.events, id: \.eventIdentifier) { event in
                            Text(event.title.trimmingCharacters(in: .whitespaces))
                                .tag(event.eventIdentifier as String?)
                        }
                    }
                }
                .scrollDisabled(true)
                .frame(minHeight: 85)
                .scrollContentBackground(.hidden)
                .offset(y: 50)
            } else {
                VStack {
                    if let identifier = selectedEventIdentifier {
                        VStack {
                            Text(calendarManager.eventStore.event(withIdentifier: identifier)?.title ?? "Unknown Event")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            if let event = calendarManager.eventStore.event(withIdentifier: identifier) {
                                Text(event.startDate, format: .dateTime.hour().minute())
                            } else {
                                Text("No event selected")
                            }
                        }
                    } else {
                        Text("Daily Outfit")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                }
                .offset(y: 50)
            }
        }
    }
