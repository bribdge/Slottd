//
//  HomeView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 23/06/2026.
//

import SwiftUI
import Foundation
import _SwiftData_SwiftUI

struct HomeView: View {
    @Query private var clothingItems: [ClothingItem]
    
    var calendar = Calendar.current
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("weekOfMonthLastOpened")
        private var weekOfMonthLastOpened = 0
    
    var body: some View {
        VStack() {
            ForEach(clothingItems) { item in
                Text(item.name)
                if item.image != nil {
                    if let image = UIImage(data: item.image!) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    } else {
                        ProgressView()
                    }
                }
            }
            
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    
    }
//        .onChange(of: scenePhase) { _, newPhase in
//            print("onChange opened - Scene phase changed to:", newPhase)
//            
//            if newPhase == .active {
//                if (calendar.component(.weekOfMonth, from: Date()) != weekOfMonthLastOpened) {
//                    print("Week of month changed.")
//                    appData.currentWeekOutfitPlan = generateWeekOutfitPlan(clothingItems: appData.clothingItems).outfitPlan
//                }
//
//                weekOfMonthLastOpened = calendar.component(.weekOfMonth, from: Date())
//                print("New week of month: \(weekOfMonthLastOpened)")
//            }
//        }
}

#Preview {
    MainTabView()
}
