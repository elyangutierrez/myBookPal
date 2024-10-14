//
//  BackgroundBookCoverView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 7/6/24.
//

import SwiftUI

struct BackgroundBookCoverView: View {
    let bookImage: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: bookImage)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .frame(width: width, height: height)
            }
        }
    }
}

#Preview {
    BackgroundBookCoverView(bookImage: "https://books.google.com/books/content?id=ydQiDQAAQBAJ&printsec=frontcover&img=1&zoom=1l&source=gbs_api", width: 300, height: 800)
}
