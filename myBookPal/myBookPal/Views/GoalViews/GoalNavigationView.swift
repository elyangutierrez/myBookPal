//
//  GoalNavigationView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import SwiftUI
import SlidingTabView

struct GoalNavigationView: View {
    var books: [Book]
    
    @State private var selection = 0
    
    var body: some View {
        NavigationStack {
            SlidingTabView(selection: $selection, tabs: ["Monthly", "Yearly"], animation: .easeInOut, selectionBarColor: .black)
            
            Spacer()
            if selection == 0 {
                MonthlyGoalsView(books: books)
            } else {
                YearlyGoalsView(books: books)
            }
        }
    }
}

//#Preview {
//    GoalNavigationView(books:)
//}
