//
//  Image.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import Foundation
import SwiftUI

extension Image {
    func ContentViewImageExtension() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .frame(width: 180, height: 210)
            .shadow(color: .black.opacity(0.30), radius: 5)
    }
    
    func AppLogoImageExtension() -> some View {
        self
            .resizable()
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .shadow(color: .black.opacity(0.70), radius: 10)
    }
    
    func SearchImageBookExtension() -> some View {
        self
            .resizable()
            .frame(width: 165, height: 245)
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .offset(y: -50)
    }
    
    func BookCoverImage() -> some View {
        self
            .interpolation(.none)
            .resizable()
            .frame(width: 200, height: 310)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
    }
}
