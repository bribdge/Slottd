//
//  wiggleViewModifier.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 11/08/2026.
//

import SwiftUI


struct WiggleViewModifier: ViewModifier {
    @State private var isWiggling = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? (isWiggling ? -0.5 : -3) : 0))
            .animation(
                .easeInOut(duration: 0.12)
                .repeatForever(autoreverses: true),
                value: isWiggling
            )
            .onAppear {
                isWiggling.toggle()
            }
    }
}

extension View {
    @ViewBuilder
    func wiggle(isEnabled: Bool) -> some View {
        if isEnabled {
            modifier(WiggleViewModifier())
        } else {
            self
        }
    }
}
