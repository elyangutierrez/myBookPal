//
//  EmptyCollectionView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/10/24.
//

import SwiftUI

struct EmptyCollectionView: View {
    var body: some View {
        VStack {
            Text("Your collection is currently empty.")
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    EmptyCollectionView()
}
