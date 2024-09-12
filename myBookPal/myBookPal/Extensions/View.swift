//
//  View.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import Foundation
import SwiftUI

extension View {
    func titleModifier() -> some View {
        return self.modifier(TitleModifier())
    }
    
    func placeHolderModifier() -> some View {
        return self.modifier(PlaceholderModifier())
    }
    
    func collectionTextModifier() -> some View {
        return self.modifier(CollectionTextModifier())
    }
}
