//
//  NewClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 27/06/2026.
//

import SwiftUI
import PhotosUI

struct NewClothingItemView: View {
    var appData: AppData
    
    @State private var returningClothingItem: ClothingItem = ClothingItem(name: "", style: .minimalist, colour: .lightBlue, type: .top, image: nil)
    
    @State private var showPopup = false
    
    @State private var selectedItem: PhotosPickerItem? // hold the selected photo
    var body: some View {
        VStack {
            List {
                Section("Clothing Item Name") {
                    TextField("Name", text: $returningClothingItem.name)
                }
                Section("Clothing Item Info") {
                    Picker("Type", selection: $returningClothingItem.type) {
                        ForEach(ClothingType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    Picker("Style", selection: $returningClothingItem.style) {
                        ForEach(ClothingStyle.allCases) { style in
                            Text(style.rawValue.capitalized)
                        }
                    }
                    Picker("Color", selection: $returningClothingItem.colour) {
                        ForEach(ClothingColor.allCases) { color in
                            Text(color.rawValue.capitalized)
                        }
                    }
                }
                Section("Clothing Image") {
                    
                    if let selectedImageData = returningClothingItem.image,
                        let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 30, maxWidth: 300)
                            .cornerRadius(25)
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            Label("Add Image", systemImage: "photo")
                    } // binds to selected item, matching means what we want to show in the picker
//                    .onChange(of: selectedItem) { _, newItem in // the first underscore is something they added. it represents the old item (the item we are changing AWAY from.) i didnt need it so its an underscore.
//                                                                // handle selected item
//                        if let newItem = newItem {
//                            Task {
//                                if let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
//                                    selectedImage = image
//                                }
//                            }
//                        }
//                    }
                    
                    if (returningClothingItem.image != nil) {
                        Button {
                            withAnimation(.easeInOut) {
                                returningClothingItem.image = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }

                    }
                }
                
            }
            
        }
        .navigationTitle("Create ToDo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                }
            }
        }
        .task(id: selectedItem) {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                returningClothingItem.image = data
            }
        }
    }
}

#Preview {
    NewClothingItemView(appData: AppData(clothingItems: [], currentWeekOutfitPlan: []))
}
