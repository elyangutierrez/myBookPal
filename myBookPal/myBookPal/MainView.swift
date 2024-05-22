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
    @State private var selectedTab = 0
    
    @AppStorage("setBookTotal") var setBookTotal = 10
    
    @AppStorage("getBookTotal") var getBookTotal = 0
    
    
    var body: some View {
        
        TabView {
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
            
            GoalNavigationView(books: books)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .tint(.black)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainView()
}
