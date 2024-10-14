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
        AsyncImage(url: URL(string: bookImage)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 200, height: 310)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .shadow(radius: 15)
                    .shadow(radius: 15)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(.clear)
                            .stroke(.black.opacity(0.60), lineWidth: 2)
                    }
            case .failure(let error):
                let _ = print("Image error", error)
                Color.red
            case .empty:
                Rectangle()
                    .fill(.clear)
                    .border(Color.black.opacity(0.20), width: 2)
                    .frame(width: 200, height: 310)
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
    BookCoverView(bookImage: "https://books.google.com/books/content?id=UAhAEAAAQBAJ&printsec=frontcover&img=1&zoom=10&source=gbs_api")
//
//    BookCoverView(bookImage: "https://books.google.com/books/content?id=25BTEAAAQBAJ&printsec=frontcover&img=1&zoom=10&source=gbs_api")
}
