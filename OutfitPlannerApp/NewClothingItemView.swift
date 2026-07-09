//
//  NewClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 27/06/2026.
//

import SwiftUI
import PhotosUI
import SwiftData

struct NewClothingItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Query private var clothingItems: [ClothingItem]
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var style: ClothingStyle = .minimalist
    @State private var colour: ClothingColor = .lightBlue
    @State private var type: ClothingType = .top
    @State private var imageData: Data? = nil
    
    @State private var showPopup = false
    
    @State private var selectedItem: PhotosPickerItem? // hold the selected photo
    var body: some View {
        VStack {
            List {
                Section("Clothing Item Name") {
                    TextField("Name", text: $name)
                }
                Section("Clothing Item Info") {
                    Picker("Type", selection: $type) {
                        ForEach(ClothingType.allCases) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    Picker("Style", selection: $style) {
                        ForEach(ClothingStyle.allCases) { style in
                            Text(style.rawValue.capitalized)
                        }
                    }
                    Picker("Color", selection: $colour) {
                        ForEach(ClothingColor.allCases) { color in
                            Text(color.rawValue.capitalized)
                        }
                    }
                }
                Section("Clothing Image") {
                    
                    if let selectedImageData = imageData,
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
                    
                    if (imageData != nil) {
                        Button {
                            withAnimation(.easeInOut) {
                                imageData = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }

                    }
                }
                
            }
            
        }
        .navigationTitle("New Clothing Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    // 1. Create it cleanly using the form's local state
                    let itemToSave = ClothingItem(
                        name: name,
                        style: style,
                        colour: colour,
                        type: type,
                        image: imageData,
                        parentOutfits: []
                    )

                    context.insert(itemToSave)
                    
                    try? context.save()
                    
                    print(clothingItems)

                    dismiss()
                }
            }
        }
        .task(id: selectedItem) {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                imageData = data
            }
        }
    }
}

#Preview {
    NavigationStack {
        NewClothingItemView()
    }
}
