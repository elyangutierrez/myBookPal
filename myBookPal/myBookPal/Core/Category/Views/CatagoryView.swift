//
//  CatagoryView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/22/24.
//

import SlidingTabView
import SwiftUI

struct CatagoryView: View {
    var books: [Book]
    
    @State private var selectedView = 0
    
    var body: some View {
        NavigationStack {
            SlidingTabView(selection: $selectedView, tabs: ["In Progress", "Completed"], selectionBarColor: Color.complement)
            
            if selectedView == 0 {
                InProgressView(books: books)
            } else {
                CompletedView(books: books)
            }
        }
        .tint(Color.complement)
        .preferredColorScheme(.light)
    }
}

//#Preview {
//    CatagoryView()
//}
