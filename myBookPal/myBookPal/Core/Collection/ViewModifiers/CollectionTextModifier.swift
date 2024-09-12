//
//  CollectionTextModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import SwiftUI

struct CollectionTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
            .fontDesign(.serif)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
}
