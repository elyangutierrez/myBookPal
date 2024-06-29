//
//  SettingsRectangleLineView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 6/27/24.
//

import SwiftUI

struct SettingsRectangleLineView: View {
    var body: some View {
        Rectangle()
            .frame(width: 330, height: 1)
            .foregroundStyle(.gray.opacity(0.20))
    }
}

#Preview {
    SettingsRectangleLineView()
}
