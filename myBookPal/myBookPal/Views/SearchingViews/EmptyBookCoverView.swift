//
//  EmptyBookCoverView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/15/24.
//

import SwiftUI

struct EmptyBookCoverView: View {
    var book: VolumeInfo
    
    var body: some View {
        Rectangle()
            .fill(.clear)
            .border(Color.black.opacity(0.50), width: 2)
            .overlay {
                Text("N/A")
            }
    }
}

//#Preview {
//    EmptyBookCoverView(book: <#T##Book#>)
//}
