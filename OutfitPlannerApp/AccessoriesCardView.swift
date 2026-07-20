//
//  AccessoriesCardView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 20/07/2026.
//

import SwiftUI

struct AccessoriesCardView: View {
    var selectedOutfit: Outfit?
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.ultraThinMaterial)
                VStack {
                    HStack {
                        if selectedOutfit?.accessories.count ?? 0 >= 1 {
                            if let selectedImageData = selectedOutfit?.accessories[0].image,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(15)
                                        .clipped()
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                        if selectedOutfit?.accessories.count ?? 0 >= 2 {
                            if let selectedImageData = selectedOutfit?.accessories[1].image,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(15)
                                        .clipped()
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                    }
                    HStack {
                        if selectedOutfit?.accessories.count ?? 0 >= 3 {
                            if let selectedImageData = selectedOutfit?.accessories[2].image,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(15)
                                        .clipped()
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                        if selectedOutfit?.accessories.count ?? 0 >= 4 {
                            if let selectedImageData = selectedOutfit?.accessories[3].image,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(15)
                                        .clipped()
                                }
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                    }
                }
                .padding()
                
            }
            Text("Accessories")
                .frame(width: 125)
                .lineLimit(1)
                .font(.system(size: 14))
        }
    }
}

#Preview {
    AccessoriesCardView()
}
