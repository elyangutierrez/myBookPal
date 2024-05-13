//
//  DetailView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the Detail View")
            }
            .navigationTitle("DetailView")
        }
    }
}

#Preview {
    DetailView()
}
