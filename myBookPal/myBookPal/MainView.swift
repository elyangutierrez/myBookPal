//
//  MainView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Query var books: [Book]
    
    var body: some View {
        TabView {
            ContentView(books: books)
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Collection")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search Book")
                }
            
            GoalNavigationView(books: books)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
        }
        .tint(.black)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainView()
}
