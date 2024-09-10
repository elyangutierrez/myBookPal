//
//  ContainerView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/5/24.
//

import SwiftUI

struct ContainerView: View {
    
    @State private var showSplashScreen = true
    
    var body: some View {
        if !showSplashScreen {
            TabsView()
        } else {
            SplashScreenView(isSplashScreenShowing: $showSplashScreen)
        }
    }
}

#Preview {
    ContainerView()
}
