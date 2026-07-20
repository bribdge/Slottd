//
//  FavoriteOutfitsView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 20/07/2026.
//
 
import SwiftUI
import SwiftData
 
struct FavoriteOutfitsView: View {
    @Query private var starredOutfits: [StarredOutfit]
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @State var searchResults: [ClothingItem] = []
    @State private var searchQuery = ""
    var isSearching: Bool { return searchQuery == "" ? false : true } // computed property! cannot use property wrapper
    
    @State private var newClothingItemSheetIsPresented = false
    @State private var path = [ClothingItem]()
    
    var backgroundColor: Color {
        if colorScheme == .light {
            return Color(red: 0.98, green: 0.97, blue: 0.93)
        } else {
            return Color(red: 0.07, green: 0.05, blue: 0.04)
        }
    }
    
    var listColor: Color {
        if colorScheme == .light {
            return Color(red: 0.94, green: 0.93, blue: 0.89)
        } else {
            return Color(red: 0.11, green: 0.09, blue: 0.08)
        }
    }
 
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                VStack {
                    List {
                        if isSearching {
                            ForEach(searchResults) { item in
                                NavigationLink(value: item) {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .frame(alignment: .leading)
                                            .font(.headline)
                                        Text("\(item.color.rawValue), \(item.type.rawValue)")
                                            .frame(alignment: .leading)
                                            .font(.subheadline)
                                    }
                                }
                                .listRowBackground(listColor)
                            }
                        } else {
                            ForEach(starredOutfits) { outfit in
                                NavigationLink(value: outfit) {
                                    VStack(alignment: .leading) {
                                        Text(outfit.occasionIdentifier ?? "Outfit")
                                            .frame(alignment: .leading)
                                            .font(.headline)
                                        Text(outfitSummary(outfit))
                                            .frame(alignment: .leading)
                                            .font(.subheadline)
                                    }
                                }
                                .listRowBackground(listColor)
                            }
                            .onDelete(perform: removeStarredOutfit)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: ClothingItem.self) { item in
                        EditClothingItemView(selectedClothingItem: item)
                    }
                    .navigationDestination(for: StarredOutfit.self) { outfit in
                        StarredOutfitDetailView(outfit: outfit)
                    }
                    .searchable(
                        text: $searchQuery,
                        placement: .automatic,
                        prompt: "Search"
                    )
                    .tint(listColor)
                }
                .navigationTitle("Favorite Outfits")
            }
            .sheet(isPresented: $newClothingItemSheetIsPresented) {
                NavigationStack {
                    NewClothingItemView()
                }
            }
            .onChange(of: searchQuery) {
                self.fetchSearchResults(query: searchQuery) // doing the filtering when search query is changed
            }
        }
    }
 
    private func outfitSummary(_ outfit: StarredOutfit) -> String {
        let pieces = [outfit.top?.name, outfit.bottom?.name, outfit.footwear?.name]
            .compactMap { $0 }
        let accessoryNames = outfit.accessories.map { $0.name }
        let all = pieces + accessoryNames
 
        return all.isEmpty ? "No items" : all.joined(separator: ", ")
    }
 
    private func fetchSearchResults(query: String) { // function for searching
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        // Pull the distinct clothing items referenced across all starred outfits
        // and filter by name. Adjust the source collection if you have a
        // dedicated @Query for all ClothingItem objects instead.
        let allItems = starredOutfits.flatMap { outfit -> [ClothingItem] in
            [outfit.top, outfit.bottom, outfit.footwear].compactMap { $0 } + outfit.accessories
        }
        withAnimation {
            searchResults = allItems.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
 
    private func removeStarredOutfit(at indexSet: IndexSet) {
        for index in indexSet {
            context.delete(starredOutfits[index])
        }
    }
}


struct StarredOutfitDetailView: View {
    let outfit: StarredOutfit
 
    var body: some View {
        List {
            Section("Occasion") {
                Text(outfit.occasionIdentifier ?? "—")
            }
            Section("Top") {
                Text(outfit.top?.name ?? "—")
            }
            Section("Bottom") {
                Text(outfit.bottom?.name ?? "—")
            }
            Section("Footwear") {
                Text(outfit.footwear?.name ?? "—")
            }
            if !outfit.accessories.isEmpty {
                Section("Accessories") {
                    ForEach(outfit.accessories) { accessory in
                        Text(accessory.name)
                    }
                }
            }
            if let rationale = outfit.rationale {
                Section("Why this outfit") {
                    Text(rationale)
                }
            }
        }
        .navigationTitle(outfit.occasionIdentifier ?? "Outfit")
    }
}
 
#Preview {
    MainTabView()
}
