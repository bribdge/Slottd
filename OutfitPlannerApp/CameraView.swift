//
//  CameraView.swift
//  OutfitPlannerApp
//
//  Created by Vedant Ganpule on 15/07/2026.
//

import SwiftUI
import Foundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var imageData: Data? // bind to the parent view state
    @Environment(\.presentationMode) var presentationMode // dismiss the view when done
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController() // creates the camera picker
        picker.delegate = context.coordinator // sets the coordinator as deleggate
        picker.sourceType = .camera // set the source to the camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // no updates needed!
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8) // passing the selected image to the parent and converting it to Data
            }
            parent.presentationMode.wrappedValue.dismiss() // dismiss the picker
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() // dismiss on cancel
        }
    }
}


#Preview {
    MainTabView()
}
