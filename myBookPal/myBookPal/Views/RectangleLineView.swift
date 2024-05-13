//
//  RectangleLineView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftUI

struct RectangleLineView: View {
    var body: some View {
        Rectangle()
            .fill(.gray.opacity(0.25))
            .frame(width: 400, height: 5)
    }
}

#Preview {
    RectangleLineView()
}
