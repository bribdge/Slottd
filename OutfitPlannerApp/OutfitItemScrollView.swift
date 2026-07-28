//
//  OutfitItemScrollView.swift
//  OutfitPlannerApp
//

import SwiftUI

struct OutfitItemScrollView: View {
    var top: ClothingItem?
    var bottom: ClothingItem?
    var footwear: ClothingItem?
    var accessories: [ClothingItem]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ClothingItemCardView(item: top)
                    .padding(.leading)

                if bottom != nil {
                    ClothingItemCardView(item: bottom)
                }

                ClothingItemCardView(item: footwear)
                    .padding(.trailing, accessories.isEmpty ? 0 : 10)

                if !accessories.isEmpty {
                    AccessoriesCardView(accessories: accessories)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

private struct ClothingItemCardView: View {
    var item: ClothingItem?
    @State private var uiImage: UIImage?

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
        .task(id: item?.image) {
            guard let data = item?.image else { uiImage = nil; return } // loads in the image in background to prevent blocking the main thread
            uiImage = UIImage(data: data)
        }
    }
}

#Preview {
    MainTabView()
}
