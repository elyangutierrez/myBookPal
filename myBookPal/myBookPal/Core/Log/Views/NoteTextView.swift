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
                    VStack(alignment: .leading) {
                        Text(note.shortenedDate)
                            .foregroundStyle(.gray)
                            .font(.headline)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        HStack {
                            VStack {
                                Text("-")
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            
                            Spacer()
                                .frame(width: 10)
                            
                            Text(note.noteText.withZeroWidthSpaces)
                               
                        }
                        .padding(.horizontal, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)
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
