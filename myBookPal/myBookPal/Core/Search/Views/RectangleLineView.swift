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
            .fill(.gray)
            .frame(width: 2, height: 30)
    }
}

#Preview {
    RectangleLineView()
}
