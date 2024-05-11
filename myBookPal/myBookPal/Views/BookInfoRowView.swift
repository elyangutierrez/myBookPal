//
//  BookInfoRowView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/10/24.
//

import SwiftUI

struct BookInfoRowView: View {
    let title: String
    let value: String
    
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    BookInfoRowView(title: "Book Name", value: "Dune")
}
