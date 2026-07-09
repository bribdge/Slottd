//
//  MainTabView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 08/07/2026.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var newClothingItemSheetIsPresented = false
    
    var body: some View {
        HStack {
            TabView {
                HomeView().tabItem() {
                    Image(systemName: "house")
                }
                HomeView().tabItem() {
                    Image(systemName: "hanger")
                }
            }
            .frame(width: 300)
            Button {
                newClothingItemSheetIsPresented.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .glassEffect(.regular.interactive().tint(.blue), in: Circle())
            }

        }
        .sheet(isPresented: $newClothingItemSheetIsPresented) {
            NavigationStack {
                NewClothingItemView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
