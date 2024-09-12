//
//  MainView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct TabsView: View {
    @Query(sort: \Book.title) var books: [Book]
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            Group {
                ContentView(books: Set(books))
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("Collection")
                    }
                
                CatagoryView(books: books)
                    .tabItem {
                        Image(systemName: "checklist")
                        Text("Catagories")
                    }
                
                SearchView(collectionBooks: books)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                SettingsView(books: books)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("More")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(Color.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TabsView()
}
