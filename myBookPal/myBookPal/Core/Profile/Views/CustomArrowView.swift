//
//  CustomArrowView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/19/24.
//

import SwiftUI

struct CustomArrowView: View {
    var body: some View {
        VStack {
            Rectangle()
                .foregroundStyle(.gray)
                .frame(width: 11, height: 2)
                .rotationEffect(.degrees(45))
                .padding(.vertical, -5)
            Rectangle()
                .foregroundStyle(.gray)
                .frame(width: 11, height: 2)
                .rotationEffect(.degrees(-45))
                .padding(.vertical, -5)
        }
    }
}

#Preview {
    CustomArrowView()
}
