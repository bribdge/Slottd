//
//  ClothingItemSelectorView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 04/08/2026.
//

import SwiftUI
import SwiftData

struct ClothingItemSelectorView: View {
    @Query var clothingItems: [ClothingItem]
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedClothingItem: ClothingItem?
    
    @State var searchResults: [ClothingItem] = []
    @State private var searchQuery = ""
    var isSearching: Bool { searchQuery != "" }
    
    var displayedItems: [ClothingItem] {
        isSearching ? searchResults : clothingItems.filter({ $0.type == selectedClothingItem?.type })
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(displayedItems) { item in
                    Button {
                        selectedClothingItem = item
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundStyle(.white)
                                Text("\(item.color.rawValue), \(item.type.rawValue)")
                                    .foregroundStyle(.gray)
                                    .frame(alignment: .leading)
                                    .font(.subheadline)
                            }
                            
                            if item.id == selectedClothingItem?.id {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .listRowBackground(Color.list)
                }
            }
            .contentMargins(.top, 0, for: .scrollContent) // removes the margin at the top of the list
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .searchable(
                text: $searchQuery,
                placement: .automatic,
                prompt: "Search"
            )
            .onChange(of: searchQuery) {
                fetchSearchResults(query: searchQuery)
            }
            .presentationDragIndicator(.visible)
        }
        .navigationTitle("Select Clothing Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
    
    private func fetchSearchResults(query: String) {
        withAnimation {
            searchResults = clothingItems.filter { $0.name.lowercased().contains(query.lowercased()) && $0.type == selectedClothingItem?.type }
        }
    }
}
