//
//  TitleModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 215, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .font(.system(size: 17).bold())
            .padding(.vertical, 2)
    }
}
