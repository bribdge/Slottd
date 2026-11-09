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
    @State private var selectedClothingItem: ClothingItem?
    
    var body: some View {
        VStack {
            List {
                ForEach(isSearching ? searchResults : clothingItems) { item in
                    Button {
                        selectedClothingItem = item
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .frame(alignment: .leading)
                                    .font(.headline)
                                    .foregroundStyle(.opposite)
                                Text("\(item.color.rawValue), \(item.type.rawValue)")
                                    .frame(alignment: .leading)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                    }
                    .listRowBackground(Color.list)
                }
            }
            .scrollContentBackground(.hidden)

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
            .navigationTitle("Clothing Items")
            .background(Color.background)
        }
        
        .sheet(item: $selectedClothingItem) { item in
            NavigationStack {
                if let data = item.image,
                   let uiImage = UIImage(data: data) {
                    EditClothingItemView(
                        selectedClothingItem: item,
                        image: uiImage
                    )
                } else {
                    EditClothingItemView(
                        selectedClothingItem: item,
                        image: UIImage()
                    )
                }
            }
            .presentationDragIndicator(.visible)
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
