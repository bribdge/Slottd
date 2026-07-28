//
//  BetaInfoSheetView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 26/07/2026.
//

import SwiftUI

struct BetaInfoSheetView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 55, weight: .bold))
                .padding()

            
            Text("Thank you.")
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
            Text("Thank you for beta testing Slottd. Please expect bugs, crashes, and rough edges as the app is still being developed. For now, treat this app as a sneak peek rather than a finished product. Your feedback is greatly appreciated!")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Built by Vedant Ganpule")
                .font(.system(size: 10))
                .foregroundStyle(.gray)
            Text("Version \(appVersion)")
                .font(.system(size: 10))
                .foregroundStyle(.gray)
        }
        .padding()
    }
}

#Preview {
    BetaInfoSheetView()
}
