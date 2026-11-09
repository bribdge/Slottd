//
//  AccessoryScrollView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 10/25/26.
//

import SwiftUI

struct AccessoryScrollView: View {
    @Binding var selectedAccessories: [ClothingItem]
    
    @Binding var isAnimating: Bool
    @Binding var isEditing: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
//                ForEach($selectedAccessories) { accessory in
//                    ClothingItemCardView(item: accessory, isEditing: $isEditing)
//                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
