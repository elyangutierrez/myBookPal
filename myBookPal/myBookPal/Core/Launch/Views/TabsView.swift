//
//  MainView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftData
import SwiftUI

struct TabsView: View {
    @Environment(\.modelContext) var modelContext
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
                
//                SearchView(collectionBooks: books)
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                        Text("Search")
//                    }
//                    .onAppear {
//                        print("TAB DEBUG: \(books)")
//                    }
                
                CurrentGoalsView(modelContext: modelContext)
                    .tabItem {
                        Image(systemName: "target")
                        Text("Goals")
                    }
                
                ProfileView(books: books)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .onAppear {
                        print("TAB DEBUG: \(books)")
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
