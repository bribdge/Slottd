//
//  DetailOutfitView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 21/07/2026.
//

import SwiftUI

struct DetailOutfitView: View {
    var selectedOutfit: StarredOutfit
    
    var body: some View {
        Text(selectedOutfit.name)
    }
}

#Preview {
    MainTabView()
}
