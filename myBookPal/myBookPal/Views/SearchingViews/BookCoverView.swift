//
//  BookCoverView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftUI

struct BookCoverView: View {
    @Environment(\.displayScale) var scale
    let bookImage: String
    
    var body: some View {
        AsyncImage(url: URL(string: bookImage), scale: scale) { phase in
            switch phase {
            case .success(let image):
                image
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            case .failure(let error):
                let _ = print("Image error", error)
                Color.red
            case .empty:
                Rectangle()
                    .fill(.clear)
                    .border(Color.black.opacity(0.20), width: 2)
                    .overlay {
                        Text("N/A")
                    }
            @unknown default:
                fatalError()
            }
        }
    }
}

#Preview {
    BookCoverView(bookImage: "https://books.google.com/books/content?id=UAhAEAAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")
}
