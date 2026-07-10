//
//  EditClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 10/07/2026.
//

import SwiftUI

struct EditClothingItemView: View {
    @Bindable var selectedClothingItem: ClothingItem
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $selectedClothingItem.name)
            }
            .navigationTitle(selectedClothingItem.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainTabView()
}
