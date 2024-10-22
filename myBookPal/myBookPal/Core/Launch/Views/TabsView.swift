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
            ContentView(books: books)
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Collection")
                }
            
            GroupsView(modelContext: modelContext, books: books)
                .tabItem {
                    Image(systemName: "rectangle.3.group.fill")
                    Text("Groups")
                }
            
            CurrentGoalsView(modelContext: modelContext)
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
            
            GeneralSettingsView(books: books)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tint(Color.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    TabsView()
}
