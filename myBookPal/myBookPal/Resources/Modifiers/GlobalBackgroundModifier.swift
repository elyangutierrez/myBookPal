//
//  GlobalBackgroundModifier.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/10/24.
//

import SwiftUI

struct GlobalBackgroundModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .ignoresSafeArea()
    }
}

//#Preview {
//    GlobalBackgroundModifier(color: Color.red)
//}
