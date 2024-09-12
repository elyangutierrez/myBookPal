//
//  PlaceholderModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import SwiftUI

struct PlaceholderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .aspectRatio(contentMode: .fit)
            .shadow(radius: 15)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .frame(width: 180, height: 210)
    }
}

//#Preview {
//    PlaceholderModifier()
//}
