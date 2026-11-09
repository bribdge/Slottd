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
                Text("Try adding some more clothing items by tapping the hanger icon to get started.")
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
                .shadow(color: .background, radius: 5)
        }
    }
}

private struct GeneratingOutfitView: View {
    @State private var blurAnimation = false
    
    var body: some View {
        VStack(spacing: 45) {
            ZStack {
                Image("calendarFrame")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .frame(width: 225, height: 225)
                    .offset(y: -20)
                TShirtAnimationView()
            }
            LoadingDots()
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                blurAnimation.toggle()
            }
        }
    }
}

private struct LoadingDots: View {
    @State var loading = false
    
    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .frame(width: 15, height: 15)
                .scaleEffect(loading ? 1.25 : 0.75)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: loading)
            Circle()
                .frame(width: 15, height: 15)
                .scaleEffect(loading ? 1.25 : 0.75)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.2), value: loading)
            Circle()
                .frame(width: 15, height: 15)
                .scaleEffect(loading ? 1.25 : 0.75)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.4), value: loading)
        }
        .onAppear() {
            self.loading = true
        }
    }
}

struct TShirtAnimationView: View {

    @State private var phase: AnimationPhase = .offRight

    private enum AnimationPhase {
        case offRight
        case center
        case offLeft
    }
    
    @State private var clothingNames = ["pants", "shirt", "shoes"]
    @State private var randomClothingImage = "shirt"

    var body: some View {

        GeometryReader { geometry in

            let offscreenOffset = geometry.size.width / 2 + 80

            let xOffset: CGFloat = {
                switch phase {
                case .offRight:
                    return offscreenOffset
                case .center:
                    return 0
                case .offLeft:
                    return -offscreenOffset
                }
            }()

            let iconScale: CGFloat = phase == .center ? 1.0 : 0.5
            let iconOpacity: Double = phase == .center ? 1.0 : 0.0

            ZStack {
                
                Image(randomClothingImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                    .offset(x: xOffset)
                

//                Image(systemName: "tshirt")
//                    .font(.system(size: 100))
//                    .foregroundStyle(.primary)
//                    .scaleEffect(iconScale)
//                    .opacity(iconOpacity)
//                    .offset(x: xOffset)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }

        .task {

            while !Task.isCancelled {

                do {
                    randomClothingImage = clothingNames.randomElement()!
                    try await Task.sleep(nanoseconds: 250_000_000)

                    withAnimation(.spring(
                        response: 0.6,
                        dampingFraction: 0.8
                    )) {
                        phase = .center
                    }

                    try await Task.sleep(nanoseconds: 700_000_000)

                    withAnimation(.easeInOut(duration: 0.55)) {
                        phase = .offLeft
                    }

                    try await Task.sleep(nanoseconds: 600_000_000)

                    phase = .offRight
                    
                } catch {
                    break
                }

            }

        }
    }
}

#Preview {
    MainTabView()
}
