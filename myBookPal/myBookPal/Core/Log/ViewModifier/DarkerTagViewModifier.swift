//
//  DarkerTagViewModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/12/24.
//

import SwiftUI

struct DarkerTagViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.system(size: 12))
            .fontWeight(.bold)
            .background(
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.accent)
                    .padding(.horizontal, -5)
                    .padding(.vertical, -8)
            )
    }
}
