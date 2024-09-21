//
//  TransferableImage.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import Foundation
import PhotosUI
import SwiftUICore
import CoreTransferable

struct TransferableImage: Transferable {
    let image: UIImage
    
    enum TransferError: Error {
        case importFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            
            return TransferableImage(image: uiImage)
        }
    }
    
}
