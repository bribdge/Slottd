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
    @State private var style: ClothingStyle = .casual
    @State private var color: ClothingColor = .white
    @State private var type: ClothingType = .top
    @State private var imageData: Data? = nil
    
    @State private var showingCamera = false
    
    @State private var selectedItem: PhotosPickerItem? // hold the selected photo
    @State private var selectedImage: UIImage? // holds the selected image
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
                    Picker("Color", selection: $color) {
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
                        CameraView(imageData: $imageData)
                            .ignoresSafeArea()
                    }
                    .presentationBackground(.black)
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
                    let itemToSave = ClothingItem(
                        name: name,
                        style: style,
                        color: color,
                        type: type,
                        image: imageData,
                        parentOutfits: []
                    )

                    context.insert(itemToSave)
                    
                    try? context.save()
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines) == "" || imageData == nil)
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
