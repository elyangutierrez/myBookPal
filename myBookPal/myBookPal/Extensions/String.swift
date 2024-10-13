//
//  String.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/30/24.
//

import Foundation
import SwiftUI

extension String {
    func toImage() -> Image? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            let uiImage = UIImage(data: data)!
            let image = Image(uiImage: uiImage)
            return image
        }
        return nil
    }
    
    var withZeroWidthSpaces: String {
        map({ String($0) }).joined(separator: "\u{200B}")
    }
}
