//
//  DetailCapsuleView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/10/24.
//

import SwiftUI

struct DetailCapsuleView: View {
    var body: some View {
        Capsule()
            .frame(width: 330, height: 30)
            .foregroundStyle(.gray.opacity(0.05))
    }
}

#Preview {
    DetailCapsuleView()
}
