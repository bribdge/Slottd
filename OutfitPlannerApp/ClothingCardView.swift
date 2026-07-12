//
//  ClothingCardView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 11/07/2026.
//

import SwiftUI

struct ClothingCardView: View {
    var clothingItem: ClothingItem
    var body: some View {
        HStack {
            ZStack {
                ZStack {
                    if clothingItem.colour.rawValue == "Multicolour" {
                        Circle()
                            .fill(Color(red: 0.47, green: 0.64, blue: 0.78).opacity(0.5))
                            .frame(width: 120, height: 120)
                            .offset(x: -60, y: -10)
                        Circle()
                            .fill(Color(red: 0.76, green: 0.48, blue: 0.47).opacity(0.5))
                            .frame(width: 140, height: 140)
                            .offset(x: 80, y: -5)
                        Circle()
                            .fill(Color(red: 0.50, green: 0.68, blue: 0.56).opacity(0.5))
                            .frame(width: 100, height: 100)
                            .offset(x: 10, y: 20)
                    } else {
                        Circle()
                            .fill(colourFromString(colour: clothingItem.colour.rawValue).opacity(0.5))
                            .frame(width: 120, height: 120)
                            .offset(x: -60, y: -10)
                        Circle()
                            .fill(colourFromString(colour: clothingItem.colour.rawValue).opacity(0.5))
                            .frame(width: 140, height: 140)
                            .offset(x: 80, y: -5)
                        Circle()
                            .fill(colourFromString(colour: clothingItem.colour.rawValue).opacity(0.5))
                            .frame(width: 100, height: 100)
                            .offset(x: 10, y: 20)
                    }
                    RoundedRectangle(cornerRadius: 35)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        if let selectedImageData = clothingItem.image,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()

                                .frame(minWidth: 100, maxWidth: 150, maxHeight: 130)
                                .clipped()
                                .cornerRadius(25)
                                .padding()
                        } else {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(minWidth: 100, maxWidth: 150)
                                .padding()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(clothingItem.type.rawValue):")
                                .font(.system(size: 20, weight: .bold))
                            Text("\(clothingItem.name)")
                                .font(.system(size: 20, weight: .regular))
                            Text("\(clothingItem.colour.rawValue), \(clothingItem.style.rawValue)")
                                .font(.system(size: 13, weight: .thin))
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(height: 150)
        .padding([.leading, .trailing])
    }
    
    func colourFromString(colour: String) -> Color {
        switch colour {
        case "White":
            return Color(red: 0.97, green: 0.97, blue: 0.95)

        case "Black":
            return Color(red: 0.18, green: 0.18, blue: 0.20)

        case "Gray":
            return Color(red: 0.67, green: 0.69, blue: 0.72)

        case "Blue":
            return Color(red: 0.47, green: 0.64, blue: 0.78) // dusty blue

        case "Red":
            return Color(red: 0.76, green: 0.48, blue: 0.47) // muted terracotta

        case "Orange":
            return Color(red: 0.86, green: 0.67, blue: 0.47) // soft apricot

        case "Green":
            return Color(red: 0.50, green: 0.68, blue: 0.56) // sage green

        case "Yellow":
            return Color(red: 0.91, green: 0.84, blue: 0.58) // warm sand

        case "Pink":
            return Color(red: 0.86, green: 0.69, blue: 0.74) // dusty rose

        case "Purple":
            return Color(red: 0.67, green: 0.60, blue: 0.77) // lavender

        case "Brown":
            return Color(red: 0.62, green: 0.53, blue: 0.45) // taupe

        default:
            return Color(red: 0.97, green: 0.97, blue: 0.95)
        }
    }
}

#Preview {
    ClothingCardView(clothingItem: ClothingItem(name: "Sweatpants", style: .comfy, colour: .red, type: .bottom, image: nil, parentOutfits: nil))
}
