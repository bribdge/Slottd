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
    
    @State var searchResults: [ClothingItem] = []
    @State private var searchQuery = ""
    var isSearching: Bool { return searchQuery == "" ? false : true } // computed property! cannot use property wrapper
    
    @State private var newClothingItemSheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if isSearching {
                        ForEach(searchResults) { item in
                            Text(item.name)
                        }
                    } else {
                        ForEach(clothingItems) { item in
                            Text(item.name)
                        }
                    }
                }
                .searchable(
                    text: $searchQuery,
                    placement: .automatic,
                    prompt: "Search"
                 )
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New Clothing Item", systemImage: "plus") {
                            newClothingItemSheetIsPresented.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Clothing Items")
        }
        .sheet(isPresented: $newClothingItemSheetIsPresented) {
            NavigationStack {
                NewClothingItemView()
            }
        }
        .onChange(of: searchQuery) {
            print("search query changed")
            self.fetchSearchResults(query: searchQuery) // doing the filtering when search query is changed
        }

        .onAppear() {
//            context.insert(newItem)
//
//            do {
//                try context.save()
//            } catch {
//                print(error)
//            }
        }
    }
    private func fetchSearchResults(query: String) { // function for searching
        withAnimation() {
            searchResults = clothingItems.filter( { $0.name.lowercased().contains(query.lowercased()) } )
        }
    }
}

#Preview {
    MainTabView()
}
