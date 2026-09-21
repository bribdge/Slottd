//
//  FavoriteOutfitsListView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 21/07/2026.
//

import SwiftUI
import SwiftData

struct FavoriteOutfitsListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Query var starredOutfits: [StarredOutfit]
    var calendarManager: CalendarManager
    
    @State var searchResults: [StarredOutfit] = []
    @State private var searchQuery = ""
    var isSearching: Bool { return searchQuery == "" ? false : true }
    
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
        NavigationStack {
            VStack {
                List {
                    if isSearching {
                        ForEach(searchResults) { outfit in
                            NavigationLink(value: outfit) {
                                Text(outfit.name)
                                    .frame(alignment: .leading)
                                    .font(.headline)
                            }
                            .listRowBackground(listColor)
                        }
                    } else {
                        ForEach(starredOutfits) { outfit in
                            NavigationLink(value: outfit) {
                                Text(outfit.name)
                                    .frame(alignment: .leading)
                                    .font(.headline)
                            }
                            .listRowBackground(listColor)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationDestination(for: StarredOutfit.self) { outfit in
                    DetailStarredOutfitView(calendarManager: calendarManager, title: outfit.name, selectedOutfit: outfit)
                }
                .searchable(
                    text: $searchQuery,
                    placement: .automatic,
                    prompt: "Search"
                )
                .tint(listColor)
            }
            .navigationTitle("Starred Outfits")
            .background(backgroundColor)
        }
        .onChange(of: searchQuery) {
            self.fetchSearchResults(query: searchQuery) // doing the filtering when search query is changed
        }
    }
    
    private func fetchSearchResults(query: String) { // function for searching
        withAnimation() {
            searchResults = starredOutfits.filter( { $0.name.lowercased().contains(query.lowercased()) } )
        }
    }
}

#Preview {
    MainTabView()
}
