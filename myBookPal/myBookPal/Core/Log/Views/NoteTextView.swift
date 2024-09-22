//
//  NoteTextView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import SwiftUI

struct NoteTextView: View {
    
    var note: QuickNote
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    VStack {
                        Text(note.noteText)
                            .background(
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(.gray.opacity(0.10))
                                    .padding(.horizontal, -10)
                                    .padding(.vertical, -7)
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .navigationTitle("Quick Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NoteTextView(note: QuickNote(noteText: "Hello, Elyan!", date: Date.now))
}
