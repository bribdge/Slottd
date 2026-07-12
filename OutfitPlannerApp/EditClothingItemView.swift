//
//  EditClothingItemView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 10/07/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditClothingItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var selectedClothingItem: ClothingItem
    @State private var isEditing: Bool = false
    
    @State private var selectedItem: PhotosPickerItem? // for photos picker (obviously)
    
    var body: some View {
        List {
            Section("Clothing Item Name") {
                if isEditing {
                    TextField("Name", text: $selectedClothingItem.name)
                } else {
                    Text(selectedClothingItem.name)
                }
            }
            Section("Clothing Item Info") {
                Picker("Type", selection: $selectedClothingItem.type) {
                    ForEach(ClothingType.allCases) { type in
                        Text(type.rawValue.capitalized)
                    }
                }.disabled(isEditing ? false : true)
                Picker("Style", selection: $selectedClothingItem.style) {
                    ForEach(ClothingStyle.allCases) { style in
                        Text(style.rawValue.capitalized)
                    }
                }.disabled(isEditing ? false : true)
                Picker("Color", selection: $selectedClothingItem.colour) {
                    ForEach(ClothingColor.allCases) { color in
                        Text(color.rawValue.capitalized)
                    }
                }.disabled(isEditing ? false : true)
            }
            Section("Clothing Image") {
                if !isEditing {
                    if let selectedImageData = selectedClothingItem.image,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 30, maxWidth: 300)
                            .cornerRadius(25)
                    } else {
                        Text("No Image Selected.")
                    }
                } else {
                    if let selectedImageData = selectedClothingItem.image,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 30, maxWidth: 300)
                            .cornerRadius(25)
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "photo")
                    }
                    
                    if (selectedClothingItem.image != nil) {
                        Button {
                            withAnimation(.easeInOut) {
                                selectedClothingItem.image = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: "pencil") {
                        withAnimation() {
                            isEditing.toggle()
                        }
                    }
                }
                    //                ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", systemImage: "trash") {
                        withAnimation() {
                            context.delete(selectedClothingItem)
                        }
                        dismiss()
                    }
                }
            } else {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        withAnimation() {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
        .task(id: selectedItem) {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                selectedClothingItem.image = data
            }
        }
    }
}

#Preview {
    EditClothingItemView(selectedClothingItem: ClothingItem(name: "Sweatpants", style: .casual, colour: .gray, type: .bottom, image: nil, parentOutfits: nil))
}
