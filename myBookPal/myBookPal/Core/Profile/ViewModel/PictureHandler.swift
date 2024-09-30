//
//  PictureHandler.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import Foundation
import PhotosUI
import SwiftUI

@Observable
class PictureHandler: @unchecked Sendable {
    var showPhotosPicker = false
    var pickerItem: PhotosPickerItem?
    var selectedImage: UIImage?
    var displayedImage: Image?
    var imageData: Data?
    var convertedString: String?
    
    func convertPickerItemToImage() async {
        guard let pickerItem else { return }
        
        if let loaded = try? await pickerItem.loadTransferable(type: TransferableImage.self) {
            let uiImage = loaded.image
            selectedImage = uiImage
            
            guard let selectedImage else { return }
            
            print(selectedImage)
            
            convertImageToString(uiimage: selectedImage)
            
            displayedImage = Image(uiImage: uiImage)
            print(displayedImage!)
            print("Got image from picker item.")
        }
    }
    
    @MainActor func convertImageToData(image: UIImage) -> Data {
        let imageData = image.jpegData(compressionQuality: 0.90)
        print("Converted image to data.")
        return imageData!
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(image: UIImage) -> String {
        guard let data = image.jpegData(compressionQuality: 0.80) else { return ""}
        
        let uuid = UUID().uuidString
        let fileName = "\(uuid).jpg"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
        
        return uuid
    }
    
    func loadImage(uuid: String) -> UIImage? {
        let filename = "\(uuid).jpg"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
    
    func convertImageToString(uiimage: UIImage) {
//        guard let uiImage = selectedImage else {
//            return
//        }
        
        let data = uiimage.jpegData(compressionQuality: 1)
        print(data!)
        let result = data?.base64EncodedString(options: .endLineWithLineFeed)
        print(result!)
        convertedString = result
    }
}
