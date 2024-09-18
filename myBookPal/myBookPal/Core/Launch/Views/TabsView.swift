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
                ContentView(books: books)
//                ContentView(books: Set(books))
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("Collection")
                    }
                    .onAppear {
                        print("TAB DEBUG: \(books)")
                    }
                
                CatagoryView(books: books)
                    .tabItem {
                        Image(systemName: "checklist")
                        Text("Catagories")
                    }
                    .onAppear {
                        print("TAB DEBUG: \(books)")
                    }
                
                SearchView(collectionBooks: books)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .onAppear {
                        print("TAB DEBUG: \(books)")
                    }
                
                SettingsView(books: books)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("More")
                    }
                    .onAppear {
                        print("TAB DEBUG: \(books)")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
//            .onAppear {
//                print("TAB DEBUG: \(books)")
//            }
        }
        .tint(Color.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TabsView()
}
