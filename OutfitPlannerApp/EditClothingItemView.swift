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
    @Environment(\.colorScheme) private var colorScheme
    
    @Bindable var selectedClothingItem: ClothingItem
    @State private var isEditing: Bool = false
    
    @State private var selectedItem: PhotosPickerItem? // for photos picker (obviously)
    @State private var showConfirmation = false
    
    @State private var showingCamera = false
    
    var backgroundColor: Color {
        if colorScheme == .light {
            return Color(red: 0.98, green: 0.97, blue: 0.96)
        } else {
            return Color(red: 0.07, green: 0.05, blue: 0.04)
        }
    }
    
    var listColor: Color {
        if colorScheme == .light {
            return Color(red: 0.95, green: 0.94, blue: 0.93)
        } else {
            return Color(red: 0.11, green: 0.09, blue: 0.08)
        }
    }
    
    var body: some View {
        VStack {
            List {
                Section("Clothing Item Name") {
                    if isEditing {
                        TextField("Name", text: $selectedClothingItem.name)
                    } else {
                        Text(selectedClothingItem.name)
                    }
                }
                .listRowBackground(listColor)
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
                    Picker("Color", selection: $selectedClothingItem.color) {
                        ForEach(ClothingColor.allCases) { color in
                            Text(color.rawValue.capitalized)
                        }
                    }.disabled(isEditing ? false : true)
                }
                .listRowBackground(listColor)
                Section("Clothing Image") {
                    if !isEditing {
                        if let selectedImageData = selectedClothingItem.image,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .cornerRadius(25)
                        } else {
                            Text("No Image Selected.")
                        }
                    } else {
                        if let selectedImageData = selectedClothingItem.image,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 300)
                                .cornerRadius(25)
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            Label("Add Photo", systemImage: "photo")
                        }
                        
                        Button(action: {
                            showingCamera = true
                        }){
                            Label("Take Photo", systemImage: "camera")
                        }
                        .sheet(isPresented: $showingCamera) {
                            CameraView(imageData: $selectedClothingItem.image)
                                .ignoresSafeArea()
                        }
                    }
                }
                .listRowBackground(listColor)
            }
            .tint(listColor)
            .scrollContentBackground(.hidden)
        }
        .background(backgroundColor)
        .navigationTitle("Edit \(selectedClothingItem.name)")
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
                                    ToolbarSpacer(placement: .topBarTrailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", systemImage: "trash") {
                        showConfirmation = true
                    }
                    .tint(.red)
                    .confirmationDialog("Delete?", isPresented: $showConfirmation) {
                        Button("Delete", role: .destructive) {
                            withAnimation() {
                                context.delete(selectedClothingItem)
                            }
                            dismiss()
                        }
                        Button("Cancel", role: .cancel) {
                           showConfirmation = false
                        }
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
    NavigationStack {
        EditClothingItemView(selectedClothingItem: ClothingItem(name: "Sweatpants", style: .casual, color: .gray, type: .bottom, image: nil, parentOutfits: nil))
    }
}
