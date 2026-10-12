//
//  PlaceholderOutfitModuleView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 17/07/2026.
//

import SwiftUI

struct PlaceholderOutfitModuleView: View {
    @Binding var isGenerating: Bool
    @Binding var unableToGenerateOutfit: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            if isGenerating {
                GeneratingOutfitView()
            } else if unableToGenerateOutfit {
                NoClothingItemsIconView()
                Text("Your closet's a little empty.")
                    .font(.system(size: 25, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("Try adding some more clothing items in the 'Clothing' tab to get started.")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(30)
    }
}

private struct NoClothingItemsIconView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "tshirt")
                .font(.system(size: 70))
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 35))
                .padding(.trailing)
                .shadow(color: .black, radius: 5)
        }
    }
}

private struct GeneratingOutfitView: View {
    var body: some View {
        VStack(spacing: 45) {
            HStack(spacing: 20) {
                RandomOutfitSlotAnimationView()
                RandomOutfitSlotAnimationView()
                RandomOutfitSlotAnimationView()
            }
            .frame(maxHeight: 100)
            Text("Generating...")
                .font(.system(size: 25, weight: .bold))
                .multilineTextAlignment(.center)
        }
    }
}

private struct RandomOutfitSlotAnimationView: View {
    @State private var iconColor = Color.opposite
    @State private var iconIsVisible = true
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.opposite, lineWidth: 4)
                .frame(minWidth: 50, maxWidth: 150, minHeight: 50, maxHeight: 150)
            Image(systemName: "tshirt")
                .font(.system(size: 45, weight: .bold))
                .foregroundStyle(iconColor)
                .opacity(iconIsVisible ? 1.0 : 0.0)
                .shadow(color: iconColor, radius: 7)
        }
        .onAppear {
            iconColor = randomColor()
            withAnimation(.spring(duration: Double.random(in: 0.3...1.5)).repeatForever(autoreverses: true)) {
                iconIsVisible.toggle()
            }
        }
    }
    
    private func randomColor() -> Color {
        return Color.init(red: Double.random(in: 0.75...1.0), green: Double.random(in: 0.3...0.5), blue: Double.random(in: 0.0...0.7))
    }
}

#Preview {
    MainTabView()
}
