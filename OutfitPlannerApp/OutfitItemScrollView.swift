//
//  OutfitItemScrollView.swift
//  OutfitPlannerApp
//

import SwiftUI

struct OutfitItemScrollView: View {
    @Binding var selectedTop: ClothingItem?
    @Binding var selectedBottom: ClothingItem?
    @Binding var selectedFootwear: ClothingItem?
    @Binding var selectedAccessories: [ClothingItem]
    
    @Binding var isAnimating: Bool
    @Binding var isEditing: Bool

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ClothingItemCardView(item: $selectedTop, isEditing: $isEditing)
                    .padding(.leading)


                if selectedBottom != nil {
                    ClothingItemCardView(item: $selectedBottom, isEditing: $isEditing)
                        .padding(.leading)
 
                }

                ClothingItemCardView(item: $selectedFootwear, isEditing: $isEditing)
                    .padding(.leading)
                    .padding(.trailing, selectedAccessories.isEmpty ? 10 : 0)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
}

struct ClothingItemCardView: View {
    @Binding var item: ClothingItem?
    @State private var uiImage: UIImage?
    
    @Binding var isEditing: Bool
    
    @State private var clothingItemSelectorIsPresented = false

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(25)
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 150, height: 150)
                        .opacity(0.5)
                        .blur(radius: 5)
                    Image(systemName: "photo.trianglebadge.exclamationmark")
                        .font(.system(size: 40, weight: .regular))
                        .offset(y: -5)
                }
            }
            Text(item?.name ?? "")
                .frame(width: 125)
                .lineLimit(1)
                .font(.system(size: 14))
        }
        .wiggle(isEnabled: isEditing)
        .onTapGesture {
            if isEditing {
                clothingItemSelectorIsPresented.toggle()
            }
        }
        .sheet(isPresented: $clothingItemSelectorIsPresented) {
            NavigationStack {
                ClothingItemSelectorView(selectedClothingItem: $item)
            }
        }
        .task(id: item?.image) {
            guard let data = item?.image else { uiImage = nil; return } // loads in the image in background to prevent blocking the main thread
            uiImage = UIImage(data: data)
        }
    }
}


#Preview {
    MainTabView()
}
