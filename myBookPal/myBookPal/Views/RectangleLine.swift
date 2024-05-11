//
//  RectangleLine.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/10/24.
//

import SwiftUI

struct RectangleLine: View {
    
    var body: some View {
        Rectangle()
            .frame(width: 330, height: 5)
            .foregroundStyle(.gray.opacity(0.30))
            .padding()
    }
}

#Preview {
    RectangleLine()
}
