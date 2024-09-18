//
//  TagTextViewModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/18/24.
//

import SwiftUI

struct TagTextViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .padding(.horizontal, 7)
            .padding(.vertical, 5)
    }
}
