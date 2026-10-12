//
//  AccessoriesCardView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 20/07/2026.
//

import SwiftUI

struct AccessoriesCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedAccessories: [ClothingItem]
    
    @State private var accessorySelectorIsPresented = false
    
    @Binding var isEditing: Bool
    
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.ultraThickMaterial)
                VStack {
                    HStack {
                        if selectedAccessories.count >= 1 {
                            if let selectedImageData = selectedAccessories[0].image,
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
                                .foregroundStyle(.gray.opacity(0.2))
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                        if selectedAccessories.count >= 2 {
                            if let selectedImageData = selectedAccessories[1].image,
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
                                .foregroundStyle(.gray.opacity(0.2))
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                    }
                    HStack {
                        if selectedAccessories.count >= 3 {
                            if let selectedImageData = selectedAccessories[2].image,
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
                                .foregroundStyle(.gray.opacity(0.2))
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                        }
                        if !isEditing {
                            if selectedAccessories.count == 4 {
                                if let selectedImageData = selectedAccessories[3].image,
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
                            } else if selectedAccessories.count >= 5 {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(.gray.opacity(0.2))
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                    
                                    Text("+\(selectedAccessories.count - 3)")
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.gray.opacity(0.2))
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color.button)
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                
                                Image(systemName: "plus")
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                            }
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
        .padding(.trailing)
        .onTapGesture {
            accessorySelectorIsPresented.toggle()
        }
        .sheet(isPresented: $accessorySelectorIsPresented) {
            NavigationStack {
                AccessorySelectorView(selectedAccessories: $selectedAccessories)
            }
        }
    }
}


#Preview {
    MainTabView()
}
