//
//  OutfitItemScrollView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 22/07/2026.
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
                if let selectedImageData = top?.image,
                   let uiImage = UIImage(data: selectedImageData) {
                    VStack(spacing: 10) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(25)
                        Text(top?.name ?? "")
                            .frame(width: 125)
                            .lineLimit(1)
                            .font(.system(size: 14))
                        
                    }
                    .padding(.leading)
                } else {
                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 150, height: 150)
                                .opacity(0.5)
                                .blur(radius: 5)
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .font(.system(size: 40, weight: .regular))
                                .offset(y: -5)
                        }
                        Text(top?.name ?? "")
                            .frame(width: 125)
                            .lineLimit(1)
                            .font(.system(size: 14))
                    }
                    .padding(.leading)
                }
                
                if bottom != nil {
                    if let selectedImageData = bottom?.image,
                       let uiImage = UIImage(data: selectedImageData) {
                        VStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(25)
                            Text(bottom?.name ?? "")
                                .frame(width: 125)
                                .lineLimit(1)
                                .font(.system(size: 14))
                        }
                    } else {
                        VStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width: 150, height: 150)
                                    .opacity(0.5)
                                    .blur(radius: 5)
                                Image(systemName: "photo.trianglebadge.exclamationmark")
                                    .font(.system(size: 40, weight: .regular))
                                    .offset(y: -5)
                            }
                            Text(bottom?.name ?? "")
                                .frame(width: 125)
                                .lineLimit(1)
                                .font(.system(size: 14))
                        }
                    }
                }
                
                if let selectedImageData = footwear?.image,
                   let uiImage = UIImage(data: selectedImageData) {
                    VStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(25)
                        Text(footwear?.name ?? "")
                            .frame(width: 125)
                            .lineLimit(1)
                            .font(.system(size: 14))
                    }
                } else {
                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 150, height: 150)
                                .opacity(0.5)
                                .blur(radius: 5)
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .font(.system(size: 40, weight: .regular))
                                .offset(y: -5)
                        }
                        Text(footwear?.name ?? "")
                            .frame(width: 125)
                            .lineLimit(1)
                            .font(.system(size: 14))
                    }
                }
                
                if accessories != [] {
                    AccessoriesCardView(accessories: accessories)
                }
            }
            
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MainTabView()
}
