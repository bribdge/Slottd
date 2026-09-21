//
//  ClothingItemsView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 10/07/2026.
//

import SwiftUI
import SwiftData

struct ClothingItemsView: View {
    @Query private var clothingItems: [ClothingItem]
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @State var searchResults: [ClothingItem] = []
    @State private var searchQuery = ""
    var isSearching: Bool { return searchQuery == "" ? false : true } // computed property! cannot use property wrapper
    
    @State private var newClothingItemSheetIsPresented = false
    
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
                    ForEach(isSearching ? searchResults : clothingItems) { item in
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
                }
                .scrollContentBackground(.hidden)
                .navigationDestination(for: ClothingItem.self) { item in
                    EditClothingItemView(selectedClothingItem: item, image: UIImage(data: item.image!))
                }
                .searchable(
                    text: $searchQuery,
                    placement: .automatic,
                    prompt: "Search"
                )
                .tint(listColor)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New Clothing Item", systemImage: "plus") {
                            newClothingItemSheetIsPresented.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Clothing Items")
            .background(backgroundColor)
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

    
    private func fetchSearchResults(query: String) { // function for searching
        withAnimation() {
            searchResults = clothingItems.filter( { $0.name.lowercased().contains(query.lowercased()) } )
        }
    }
    
    private func removeClothingItem(at indexSet: IndexSet) {
        for index in indexSet {
            context.delete(clothingItems[index])
        }
    }
        
}

#Preview {
    MainTabView()
}
