//
//  CalendarManager.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 11/07/2026.
//

import SwiftUI
import EventKit
import Observation

@Observable
@MainActor // keeps us on the main thread
class CalendarManager {
    private let eventStore = EKEventStore() // create only one EKEventStore as creating one uses lots of resources
    
    var events: [EKEvent] = []
    var authorizationStatus: EKAuthorizationStatus = .notDetermined // we dont know if the user has accepted access to the calendar, so this is not determined.
    var errorMessage: String? // will be used in a popup view later on
    
    func requestAccess() async {
        do {
            let granted = try await eventStore.requestFullAccessToEvents() // asking for full access to events
            
            if granted {
                authorizationStatus = .fullAccess
                fetchEvents()
            } else {
                authorizationStatus = .denied
                errorMessage = "Calendar access denied. Please enable in Settings."
            }
        } catch {
            errorMessage = "Failed to access calendar. \(error)"
        }
    }
    
    func checkAuthorizationStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func fetchEvents() {
        let startDate = Calendar.current.startOfDay(for: .now) // defining a range from which we want to fetch events
        guard let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startDate)
        else {return}
        
        let calendars = eventStore.calendars(for: .event)
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        
        let fetchedEvents = eventStore.events(matching: predicate)
        events = fetchedEvents.sorted{ $0.startDate < $1.endDate }
    }
}

#Preview {
    MainTabView()
}
