//
//  SplashScreenView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/5/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    
    @Binding var isSplashScreenShowing: Bool
    @State private var scale: CGSize = CGSize(width: 0.9, height: 0.9)
    
    var body: some View {
        ZStack {
            ZStack {
                Image(.appLogo)
                    .AppLogoImageExtension()
            }
        }
        .scaleEffect(scale)
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.easeIn(duration: 0.7)) {
                scale = CGSize(width: 1.1, height: 1.1)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.smooth(duration: 0.4)) {
                    isSplashScreenShowing.toggle()
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(isSplashScreenShowing: .constant(true))
}
