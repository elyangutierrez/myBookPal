//
//  MainView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Collection")
                }
            AddView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Add Book")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainView()
}
