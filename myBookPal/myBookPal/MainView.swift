//
//  MainView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Query(sort: \Book.title) var books: [Book]
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            Group {
                ContentView(books: books)
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("Collection")
                    }
                
                CatagoryView(books: books)
                    .tabItem {
                        Image(systemName: "checklist")
                        Text("Catagories")
                    }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                SettingsView(books: books)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(.black)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainView()
}
