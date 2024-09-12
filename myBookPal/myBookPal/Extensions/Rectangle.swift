//
//  Rectangle.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import Foundation
import SwiftUI

extension Rectangle {
    func StarRatingExtension(rating: Double, proxy: GeometryProxy, stars: some View) -> some View {
        self
            .foregroundStyle(.starYellow)
            .frame(width: CGFloat(rating) / 5 * proxy.size.width)
            .frame(maxWidth: .infinity, alignment: .leading)
            .mask(stars)
    }
}
