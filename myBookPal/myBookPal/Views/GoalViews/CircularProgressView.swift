//
//  CircularProgressView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .frame(width: 200, height: 200)
                .opacity(0.1)
                .foregroundStyle(.blue)
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .frame(width: 200, height: 200)
                .foregroundStyle(progress == 1.0 ? .green : .blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
    }
}


#Preview {
    CircularProgressView(progress: 1.0)
}
