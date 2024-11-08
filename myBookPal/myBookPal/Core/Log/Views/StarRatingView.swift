//
//  StarRatingTwoView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/7/24.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Double
    
    var body: some View {
        stars
            .overlay{
                GeometryReader { proxy in
                    Rectangle()
                        .StarRatingExtension(rating: rating, proxy: proxy, stars: stars)
                }
            }
    }
    
    private var stars: some View {
        HStack {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: "star.fill")
                    .foregroundStyle(.starGrey)
                    .padding(.horizontal, -2)
            }
        }
    }
}

#Preview {
    StarRatingView(rating: 3.65)
}
